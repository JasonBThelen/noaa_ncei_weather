module NoaaNceiWeather
  class Location < Weather
    @@endpoint = 'locations'
    attr_reader :mindate, :maxdate, :name, :datacoverage, :id
    def initialize(id, name, datacoverage, mindate, maxdate)
      super(id, name)
      @datacoverage = datacoverage
      @mindate = mindate
      @maxdate = maxdate
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

    def self.find(id)
      data = super(@@endpoint + "/#{id}")
      if data && data.any?
        self.new data['id'], data['name'], data['datacoverage'], Date.parse(data['mindate']), Date.parse(data['maxdate'])
      else
        nil
      end
    end

    def self.find_by_zip(zip)
      self.find("ZIP:#{zip}")
    end

    def self.where(params = {})
      data = super(@@endpoint, params)
      if data && data.any?
        data.collect {|item| self.new item['id'], item['name'], item['datacoverage'], Date.parse(item['mindate']), Date.parse(item['maxdate'])}
      else
        []
      end
    end
  end
end
