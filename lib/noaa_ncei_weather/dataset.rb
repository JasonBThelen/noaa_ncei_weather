module NoaaNceiWeather
  class Dataset < Weather
    @@endpoint = 'datasets'
    attr_reader :uid, :mindate, :maxdate, :name, :datacoverage, :id

    def initialize(id, uid, name, datacoverage, mindate, maxdate)
      super(id, name)
      @uid = uid
      @datacoverage = datacoverage
      @mindate = mindate
      @maxdate = maxdate
    end

    def data_categories(params = {})
      params.merge!({datasetid: @id})
      DataCategory.where(params)
    end

    def data_types(params = {})
      params.merge!({datasetid: @id})
      DataType.where(params)
    end

    def location_categories(params = {})
      params.merge!({datasetid: @id})
      LocationCategory.where(params)
    end

    def locations(params = {})
      params.merge!({datasetid: @id})
      Location.where(params)
    end

    def stations(params = {})
      params.merge!({datasetid: @id})
      Station.where(params)
    end

    def self.find(id)
      data = super(@@endpoint + "/#{id}")
      if data && data.any?
        self.new data['id'], data['uid'], data['name'], data['datacoverage'], Date.parse(data['mindate']), Date.parse(data['maxdate'])
      else
        nil
      end
    end

    def self.where(params = {})
      data = super(@@endpoint, params)
      if data && data.any?
        data.collect { |item| self.new item['id'], item['uid'], item['name'], item['datacoverage'], Date.parse(item['mindate']), Date.parse(item['maxdate']) }
      else
        []
      end
    end
  end
end
