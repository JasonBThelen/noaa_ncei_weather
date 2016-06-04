module NoaaNceiWeather
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

    def data_sets(params = {})
      params.merge!({locationid: @id})
      Dataset.where(params)
    end

    def data_categories(params = {})
      params.merge!({locationid: @id})
      DataCategory.where(params)
    end

    def data_types(params = {})
      params.merge!({locationid: @id})
      DataType.where(params)
    end

    def stations(params = {})
      params.merge!({locationid: @id})
      Station.where(params)
    end

    def self.where(params = {})
      super(@@endpoint, params)
    end
  end
end
