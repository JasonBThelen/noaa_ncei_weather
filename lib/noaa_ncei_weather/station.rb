module NoaaNceiWeather
  class Station < Weather
    @@endpoint = 'stations'
    attr_reader :elevation, :mindate, :maxdate, :latitude, :name, :datacoverage, :id, :elevationunit, :longitude
    def initialize(id, name, datacoverage, mindate, maxdate, elevation, elevationUnit, latitude, longitude)
      super(id, name)
      @datacoverage = datacoverage
      @mindate = mindate
      @maxdate = maxdate
      @elevation = elevation
      @elevationunit = elevationUnit
      @latitude = latitude
      @longitude = longitude
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
      data = super(@@endpoint + "/#{id}")
      if data && data.any?
        self.new data['id'], data['name'], data['datacoverage'], Date.parse(data['mindate']), Date.parse(data['maxdate']), data['elevation'], data['elevationUnit'], data['latitude'], data['longitude']
      else
        nil
      end
    end

    def self.find_by_zip(zip)
      self.where(locationid: "ZIP:#{zip}")
    end

    def self.where(params = {})
      data = super(@@endpoint, params)
      if data && data.any?
        data.collect do |item|
          self.new item['id'], item['name'], item['datacoverage'], Date.parse(item['mindate']), Date.parse(item['maxdate']), item['elevation'], item['elevationUnit'], item['latitude'], item['longitude']
        end
      else
        []
      end
    end
  end
end
