require "noaa_ncei_weather/version"

module NoaaNceiWeather
  require "rest-client"

  module Connection
    @@url = 'http://www.ncdc.noaa.gov/cdo-web/api/v2/'
    @@token = ''

    def self.token=(token)
      @@token = token
    end

    def self.request(endpoint, params = {})
      url = @@url + endpoint
      begin
        response = RestClient::Request.execute(method: 'get', url: url, headers: {token: @@token, params: params})
        JSON.parse(response.body)
      rescue RestClient::ExceptionWithResponse => err
        err.response
      end
    end
  end

  class Weather
    def self.all
      self.where
    end
    def self.where(endpoint, params = {})
      data = Connection.request(endpoint, params)['results']
      dslist = []
      data.each do |dataset|
        set = self.new(dataset)
        dslist.push(set)
      end
      return dslist
    end
  end

  class Dataset < Weather
    @@endpoint = 'datasets'
    attr_reader :uid, :mindate, :maxdate, :name, :datacoverage, :id

    def initialize(params)
      @uid = params['uid']
      @mindate = Date.parse(params['mindate'])
      @maxdate = Date.parse(params['maxdate'])
      @name = params['name']
      @datacoverage = params['datacoverage']
      @id = params['id']
    end

    def data_categories(params = {})
      params.merge!({datasetid: @id})
      DataCategory.where(params)
    end

    def self.where(params = {})
      super(@@endpoint, params)
    end
  end

  class DataCategory < Weather
    @@endpoint = 'datacategories'
    attr_reader :name, :id
    def initialize(params)
      @name = params['name']
      @id = params['id']
    end

    def data_types(params = {})
      params.merge!({datacategoryid: @id})
      DataType.where(params)
    end

    def self.where(params = {})
      super(@@endpoint, params)
    end
  end

  class DataType < Weather
    @@endpoint = 'datatypes'
    attr_reader :mindate, :maxdate, :name, :datacoverage, :id
    def initialize(params)
      @mindate = Date.parse(params['mindate'])
      @maxdate = Date.parse(params['maxdate'])
      @name = params['name']
      @datacoverage = params['datacoverage']
      @id = params['id']
    end

    def self.where(params = {})
      super(@@endpoint, params)
    end
  end

  class LocationCategory < Weather
    @@endpoint = 'locationcategories'
    attr_reader :name, :id
    def initialize(params)
      @name = params['name']
      @id = params['id']
    end

    def self.where(params = {})
      super(@@endpoint, params)
    end
  end

  class Locations < Weather
    @@endpoint = 'locations'
    attr_reader :mindate, :maxdate, :name, :datacoverage, :id
    def initialize(params)
      @mindate = Date.parse(params['mindate'])
      @maxdate = Date.parse(params['maxdate'])
      @name = params['name']
      @datacoverage = params['datacoverage']
      @id = params['id']
    end

    def self.where(params = {})
      super(@@endpoint, params)
    end
  end

  class Stations < Weather
    @@endpoint = 'stations'
    attr_reader :elevation, :mindate, :maxdate, :latitude, :name, :datacoverage, :id, :elevationunit, :longitude
    def initialize(params)
      @elevation = params['elevation']
      @mindate = Date.parse(params['mindate'])
      @maxdate = Date.parse(params['maxdate'])
      @latitude = params['latitude']
      @name = params['name']
      @datacoverage = params['datacoverage']
      @id = params['id']
      @elevationunit = ['elevationunit']
    end

    def self.where(params = {})
      super(@@endpoint, params)
    end
  end

  class Data < Weather
    @@endpoint = 'data'
    attr_reader :date, :datatype, :station, :attributes, :value
    def initialize(params)
      @date = Date.parse(params['date'])
      @datatype = params['datatype']
      @station = params['station']
      @attributes = params['attributes']
      @value = params['value']
    end

    def self.where(params = {})
      super(@@endpoint, params)
    end
  end

end
