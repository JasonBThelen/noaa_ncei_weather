module NoaaNceiWeather
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

    def self.all(*args)
      []
    end

    def self.find(*args)
      nil
    end

    def self.first(*args)
      nil
    end

    def self.where(datasetid, startdate, enddate, params = {})
      datasetid = datasetid.id if datasetid.respond_to?(:id)
      params.merge!({datasetid: datasetid, startdate: startdate, enddate: enddate})
      super(@@endpoint, params)
    end
  end
end
