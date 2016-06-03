module NoaaNceiWeather
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
end