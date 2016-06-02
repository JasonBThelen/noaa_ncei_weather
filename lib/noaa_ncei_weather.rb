module NoaaNceiWeather
  class Weather
    attr_writer :token
    @params = {}
    @@url = 'http://www.ncdc.noaa.gov/cdo-web/api/v2/'

    def initialize(token, params = {})
      @token = token
      @params = params
    end

    def params
      @params
    end

    def params=(params)
      @params.merge!(params)
    end

    def params_reset
      @params = {}
    end

    # Datasets: Set of information from which specific data can be pulled
    ## Each is like a table with different columns
    ## Examples are "Annual Summaries", "Daily Summaries", Radar, "Precipitation Hourly"
    def query_datasets(params = {})
      data = request('datasets', @params.merge(params))
      return data['results']
    end

    def dataset_info(id = params[:datasetid])
      data = request("datasets/#{id}")
      return data
    end

    # Data Categories: Categories in which the data types fall
    def query_datacategories(params = {})
      data = request('datacategories', params)
      return data['results']
    end

    def datacategory_info(id = params[:datacategoryid])
      data = request("datacategories/#{id}")
      return data
    end

    # Data Types: Columns of data that can be pulled
    def query_datatypes(params = {})
      data = request('datatypes', params)
      return data['results']
    end

    def datatype_info(id = params[:datatypeid])
      data = request("datatypes/#{id}")
      return data
    end

    # Location Categories: Type of location, like state or zip
    def query_location_categories(params = {})
      data = request('locationcategories', @params.merge(params))
      return data['results']
    end

    def locationcategory_info(id = params[:locationcategoryid])
      data = request("locationcategories/#{id}")
      return data
    end

    # Location: Can be a long/lat point like a station, or an area like a city, state, or zip
    def query_locations(params = {})
      data = request('locations', @params.merge(params))
      return data['results']
    end

    def location_info(id = params[:locationid])
      data = request("locations/#{id}")
      return data
    end

    # Station: A specific long/lat point location, where weather information is measured and reported
    def query_stations(params = {})
      data = request('stations', @params.merge(params))
      return data['results']
    end

    def station_info(id = params[:stationid])
      data = self.request("stations/#{id}")
      return data
    end

    # Data: used for actually fetching specific data after using the other information to set the appropriate parameters
    def query_data(params = {})
      data = request('data', @params.merge(params))
      return data['results']
    end

    private
    def request(endpoint, params = {})
      url = @@url + endpoint
      begin
        response = RestClient::Request.execute(method: 'get', url: url, headers: {token: @token, params: params})
        JSON.parse(response.body)
      rescue RestClient::ExceptionWithResponse => err
        err.response
      end
    end

  end
end
