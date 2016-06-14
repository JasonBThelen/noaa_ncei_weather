module NoaaNceiWeather
  class DataType < Weather
    @@endpoint = 'datatypes'
    attr_reader :mindate, :maxdate, :name, :datacoverage, :id
    def initialize(id, name, datacoverage, mindate, maxdate)
      super(id, name)
      @datacoverage = datacoverage
      @mindate = mindate
      @maxdate = maxdate
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
      data = super(@@endpoint + "/#{id}")
      if data && data.any?
        self.new data['id'], data['name'], data['datacoverage'], Date.parse(data['mindate']), Date.parse(data['maxdate'])
      else
        nil
      end
    end

    def self.where(params = {})
      data = super(@@endpoint, params)
      if data && data.any?
        data.collect { |item| self.new item['id'], item['name'], item['datacoverage'], Date.parse(item['mindate']), Date.parse(item['maxdate']) }
      else
        []
      end

    end
  end
end
