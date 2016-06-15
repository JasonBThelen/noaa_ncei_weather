module NoaaNceiWeather

  # @abstract Superclass to all of the resource classes used to help filter data
  #   queried using {Data}
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

    # Used to query for a single ID
    def self.find(endpoint)
      self.request(endpoint)
    end

    # Used to retrieve a single record with no specification
    def self.first
      self.where(limit: 1).first
    end
  end
end
