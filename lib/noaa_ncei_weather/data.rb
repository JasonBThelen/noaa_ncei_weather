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

    def self.where(params = {})
      super(@@endpoint, params)
    end
  end
end
