module NoaaNceiWeather

  # Class for querying against the /datacategory endpoint of the NOAA API
  class DataType < Weather

    # Endpoint portion of the API URL, appended to the Connection URL for requests
    @@endpoint = 'datatypes'

    # @!attribute [r] id
    #   @return [String] The unique Identifier
    # @!attribute [r] name
    #   @return [String] The descriptive name
    # @!attribute [r] datacoverage
    #   @return [Numeric] The estimated completeness of data, value between 0 and 1
    # @!attribute [r] mindate
    #   @return [Date] Earliest availability of data with this type
    # @!attribute [r] maxdate
    #   @return [String] Latest availability of data with this type
  attr_reader :mindate, :maxdate, :datacoverage

    # Creates new {DataType} object
    def initialize(id, name, datacoverage, mindate, maxdate)
      super(id, name)
      @datacoverage = datacoverage
      @mindate = mindate
      @maxdate = maxdate
    end

    # Retrieves the {Dataset} that this instance of {DataType} belongs to
    # {Dataset} has a one to many relationship with {DataType}.
    #
    # @return [Dataset] The {Dataset} object that this instance of {DataType} belongs to
    def dataset
      Dataset.where(datatypeid: @id).first
    end

    # Retrieves the {Station Stations} that are associated with this instance
    # of {DataType}. {DataType} and {Station} have a many to many relationship
    #
    # @param params [Hash] See {NoaaNceiWeather::Station#where} for valid key/values
    # @return [Array<Station>] An Array of {Station} objects assocated with the
    #   instance of {DataType}
    def stations(params = {})
      params.merge!({datatypeid: @id})
      Station.where(params)
    end

    # Finds a specific instance of {DataType} by its ID
    #
    # @param id [String] String ID of the resource
    # @return [DataCategory, nil] Instance of {DataCategory}, or nil if none found
    def self.find(id)
      data = super(@@endpoint + "/#{id}")
      if data && data.any?
        self.new data['id'], data['name'], data['datacoverage'], Date.parse(data['mindate']), Date.parse(data['maxdate'])
      else
        nil
      end
    end

    # Finds a set of {DataType DataTypes} based on the parameters given
    #
    # @param params [Hash] Hash to set filters on the request sent to the NOAA API
    # @option params [String] :datasetid Filter data types by their {Dataset}
    # @option params [Dataset] :dataset Alternative way to pass :datasetid
    # @option params [String] :locationid Restrict data to measurements from
    #   stations in a locationid
    # @option params [Location] :location Alternative way to pass :locationid
    # @option params [String] :stationid Restrict data to measurements from a
    #   specific station
    # @option params [Station] :station Alternative way to pass :stationid
    # @option params [String] :datacategoryid Restrict data types by their {DataCategory}
    # @option params [DataCategory] :datacategory Alternative way to pass :datacategoryid
    # @option params [Date, String] :startdate Date or ISO formmated string to
    #   restrict data types to those with data after this date
    # @option params [Date, String] :enddate Date or ISO formatted string to
    #   restrict data types to those with data before this date
    # @option params [String] :sortfield ('id') Accepts string values 'id', 'name,
    #   'mindate', 'maxdate', and 'datacoverage' to sort data before being returned
    # @option params [String] :sortorder ('asc') Accepts 'asc' or 'desc' for sort order
    # @option params [Integer] :limit Set a limit to the amount of records returned
    # @option params [Integer] :offset (0) Used to offset the result list
    def self.where(params = {})
      data = super(@@endpoint, params)
      if data && data.any?
        data.collect { |item| self.new item['id'], item['name'], item['datacoverage'], Date.parse(item['mindate']), Date.parse(item['maxdate']) }
      else
        []
      end

    end
  end
end
