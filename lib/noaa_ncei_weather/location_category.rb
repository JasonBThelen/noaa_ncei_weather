module NoaaNceiWeather
  class LocationCategory < Weather
    @@endpoint = 'locationcategories'
    attr_reader :name, :id
    def initialize(params)
      @name = params['name']
      @id = params['id']
    end

    def locations(params = {})
      params.merge!({locationcategoryid: @id})
      LocationCategory.where(params)
    end

    def self.where(params = {})
      super(@@endpoint, params)
    end
  end
end
