module NoaaNceiWeather
  class DataCategory < Weather
    @@endpoint = 'datacategories'
    attr_reader :name, :id
    def initialize(params)
      @name = params['name']
      @id = params['id']
    end

    def data_types(params = {})
      params.merge!({datacategoryid: @id})
      DataType.where(params)
    end

    def self.where(params = {})
      super(@@endpoint, params)
    end
  end
end
