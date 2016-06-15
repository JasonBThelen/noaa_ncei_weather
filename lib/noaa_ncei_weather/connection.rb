module NoaaNceiWeather

  # @abstract Contains common connection components shared between {Weather} and {Data}
  #   used to make requests to the NOAA API.
  module Connection
    # Base URL for the NOAA API. Endppoints are appended in concrete classes.
    @@url = 'http://www.ncdc.noaa.gov/cdo-web/api/v2/'

    # Connection token required to make requests. Must be set before calling
    # class methods from any NoaaNceiWeather module classes.
    # @note Each Token is restricted to five request per second and 1,000 requests
    #   per day per the NOAA documentation
    @@token = ''

    # Set the request token to be used in requests to NOAA. Token must be obtained
    # from {http://www.ncdc.noaa.gov/cdo-web/token NOAA}. Use this before trying
    # to make any requests:
    #   NoaaNceiWeather::Connection.token = 'token'
    #
    # @!attribute [w] token
    #   @return [String] Token required to be sent with any requests. This can be
    #     obtained for free from {http://www.ncdc.noaa.gov/cdo-web/token NOAA}.
    #     The token is good for 5 requests per second, 1,000 requests per day.
    def self.token=(token)
      @@token = token
    end

    # Parses params to the format expected by the API. Allows more flexibility in what can
    # be sent in as a parameter. Objects, Dates, and Limits are converted
    # into strings as expected by the API.
    #
    # @param params [Hash] Hash of params to be parsed into an API compatible version
    # @return [Hash] Hash of params. Objects are converted into IDs, Dates are
    #   converted into iso formatted strings, and max limit is set at 1000
    def parse_params(params)
      # Handle passing of weather objects as parameters for other api queries
      objects = [:dataset, :datatype, :location, :station, :datacategory, :locationcategory]
      objects.each do |object|
        params[(object.to_s + "id").to_sym] = params.delete(object).id if params.has_key?(object)
      end

      # Handle Date, DateTime, or Time parameters
      # Convert to formatted string the api is expecting
      dates = [:startdate, :enddate]
      dates.each do |date|
        params[date] = params[date].iso8601 if params[date].respond_to?(:iso8601)
      end

      # Prep for handling requests for over the 1k NOAA limit
      params[:limit] = 1000 unless params[:limit] && params[:limit] < 1000

      #return modified params
      params
    end

    # Raw request sent via RestClient to the API. Used by all other requests
    #
    # @param endpoint [String] Endpoint of the API to be used. This is set as a
    #   class variable by each of the concerete classes in this gem.
    # @param params [Hash] Hash of params to be passed through to the API
    # @return [Hash] Hashified version of the response body received, includes
    #   both actual data and metadata about the resultset
    def request(endpoint, params = {})
      url = @@url + endpoint
      response = RestClient::Request.execute(method: 'get', url: url, headers: {token: @@token, params: params})
      JSON.parse(response.body)
    end

    # Request with parameters used by child classes. Handles NOAA max limit of 1000
    # records by looping through the request.
    #
    # @param endpoint [String] Endpoint of the API to be used. This is set as a
    #   class variable by each of the concerete classes in this gem.
    # @param params [Hash] Hash of params to be passed through to the API
    # @return [Array<Hash>] Array of Hashes containing data only of the result (no metadata)
    def where(endpoint, params = {})
      limit = params[:limit] || Float::INFINITY
      params = self.parse_params(params)
      output = []
      begin
        response = self.request(endpoint, params)
        break unless response.any?
        meta = response['metadata']['resultset']
        output.concat response['results']
        count = meta['offset'] + meta['limit'] - 1
        params[:offset] = count + 1
        params[:limit] = limit - count if (limit - count) < 1000
      end while count < meta['count'] && count < limit && limit > 1000
      output
    end
  end
end
