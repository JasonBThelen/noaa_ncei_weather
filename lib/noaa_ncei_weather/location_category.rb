module NoaaNceiWeather
  class LocationCategory < Weather
    @@endpoint = 'locationcategories'
    attr_reader :name, :id
    def initialize(params)
      @name = params['name']
      @id = params['id']
    end

    def self.where(params = {})
      super(@@endpoint, params)
    end
  end
end
