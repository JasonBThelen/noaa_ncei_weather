module NoaaNceiWeather

  class Weather
    extend Connection

    # @!attribute [r] id
    #   @return [String] The unique Identifier of the resource
    # @!attribute [r] name
    #   @return [String] The descriptive name of the resource
    attr_reader :name, :id

    # Creates a new Weather object
    def initialize(id, name)
      @id = id
      @name = name
    end

    # Used to query for all the resources without any filter
    #
    # @return [Array<Weather>] Returns an array of objects, whichever type is being queried
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
