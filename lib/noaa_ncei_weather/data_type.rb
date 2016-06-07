module NoaaNceiWeather
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

    # DataType belongs to a Data Set
    def dataset(params = {})
      params.merge!({datatypeid: @id})
      Dataset.where(params).first
    end

    def stations(params = {})
      params.merge!({datatypeid: @id})
      Station.where(params)
    end

    def self.find(id)
      super(@@endpoint + "/#{id}")
    end

    def self.where(params = {})
      super(@@endpoint, params)
    end
  end
end
