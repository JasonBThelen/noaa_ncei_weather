module NoaaNceiWeather
  module Connection
    @@url = 'http://www.ncdc.noaa.gov/cdo-web/api/v2/'
    @@token = ''

    def self.token=(token)
      @@token = token
    end

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

    def request(endpoint, params = {})
      url = @@url + endpoint
      response = RestClient::Request.execute(method: 'get', url: url, headers: {token: @@token, params: params})
      JSON.parse(response.body)
    end

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
