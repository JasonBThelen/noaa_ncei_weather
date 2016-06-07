module NoaaNceiWeather
  class Station < Weather
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
      @elevationunit = params['elevationunit']
    end

    def data_sets(params = {})
      params.merge!({stationid: @id})
      Dataset.where(params)
    end

    def data_categories(params = {})
      params.merge!({stationid: @id})
      DataCategory.where(params)
    end

    def data_types(params = {})
      params.merge!({stationid: @id})
      DataType.where(params)
    end

    def self.find(id)
      super(@@endpoint + "/#{id}")
    end

    def self.where(params = {})
      super(@@endpoint, params)
    end
  end
end
