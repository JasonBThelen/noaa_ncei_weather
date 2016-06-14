module NoaaNceiWeather
  class Weather
    extend Connection
    attr_reader :name, :id

    def initialize(id, name)
      @id = id
      @name = name
    end

    def self.all
      self.where
    end

    def self.find(endpoint)
      self.request(endpoint)
    end

    def self.first
      self.where(limit: 1).first
    end
  end
end
