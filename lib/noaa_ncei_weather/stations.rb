module NoaaNceiWeather
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
end
