module NoaaNceiWeather

  # Class for querying against the /datacategory endpoint of the NOAA API
  class Location < Weather

    # Endpoint portion of the API URL, appended to the Connection URL for requests
    @@endpoint = 'locations'

    # @!attribute [r] id
    #   @return [String] The unique Identifier
    # @!attribute [r] name
    #   @return [String] The descriptive name
    # @!attribute [r] datacoverage
    #   @return [Numeric] The estimated completeness of data, value between 0 and 1
    # @!attribute [r] mindate
    #   @return [Date] Earliest availability of data in this set
    # @!attribute [r] maxdate
    #   @return [String] Latest availability of data in this set
    attr_reader :mindate, :maxdate, :datacoverage

    # Creates a new instance of {Location}
    def initialize(id, name, datacoverage, mindate, maxdate)
      super(id, name)
      @datacoverage = datacoverage
      @mindate = mindate
      @maxdate = maxdate
    end

    # Retrieves a collection of {Dataset} objects associated with this instance
    #   of {Location}
    #
    # @param params [Hash] See {Dataset#where} for valid key/values.
    # @return [Array<Dataset>] An array of {Dataset} objects associated with this
    #   instance of {Location}
    def data_sets(params = {})
      params.merge!({locationid: @id})
      Dataset.where(params)
    end

    # Retrieves a collection of {DataCategory} objects associated with this instance
    #   of {Location}
    #
    # @param params [Hash] See {DataCategory#where} for valid key/values.
    # @return [Array<DataCategory>] An array of {DataCategory} objects associated with this
    #   instance of {Location}
    def data_categories(params = {})
      params.merge!({locationid: @id})
      DataCategory.where(params)
    end

    # Retrieves a collection of {DataType} objects associated with this instance
    #   of {Location}
    #
    # @param params [Hash] See {DataType#where} for valid key/values.
    # @return [Array<DataType>] An array of {DataType} objects associated with this
    #   instance of {Location}
    def data_types(params = {})
      params.merge!({locationid: @id})
      DataType.where(params)
    end

    # Retrieves a collection of {Station} objects associated with this instance
    #   of {Location}
    #
    # @param params [Hash] See {Station#where} for valid key/values.
    # @return [Array<Station>] An array of {Station} objects associated with this
    #   instance of {Location}
    def stations(params = {})
      params.merge!({locationid: @id})
      Station.where(params)
    end

    # Find the {LocationCategory} that this Location belongs to
    #
    # @return [LocationCategory] {LocationCategory} object that this instance of
    #   {Location} belongs to
    def location_category
      locationcategoryid = self.id.split(":")[0]
      LocationCategory.find(locationcategoryid)
    end

    # Finds a specific instance of {Location} by its ID
    #
    # @param id [String] String ID of the resource.
    # @return [Location, nil] Instance of {Location}, or nil if none found.
    def self.find(id)
      data = super(@@endpoint + "/#{id}")
      if data && data.any?
        self.new data['id'], data['name'], data['datacoverage'], Date.parse(data['mindate']), Date.parse(data['maxdate'])
      else
        nil
      end
    end

    # Find a Location based on Zip code. Generates a locationid with the zip and
    #   uses #find to return the object
    #
    # @param zip [String] Five digit zip code
    # @return [Location, nil] Instance of {Location}, or nil if none found.
    def self.find_by_zip(zip)
      self.find("ZIP:#{zip}")
    end

    # Finds a set of {Location Locations} based on the parameters given
    #
    # @param params [Hash] Hash to set filters on the request sent to the NOAA API
    # @option params [String] :datasetid Filter data types by their {DataSet}
    # @option params [DataSet] :dataset Alternative way to pass :datasetid
    # @option params [String] :locationid Restrict data to measurements from
    #   stations in a locationid
    # @option params [Location] :location Alternative way to pass :locationid
    # @option params [String] :datacategoryid Restrict locations to those with
    #   data from a specific data category
    # @option params [DataCategory] :datacategory Alternative way to pass :datacategoryid
    # @option params [Date, String] :startdate Date or ISO formmated string to
    #   restrict data sets to those with data after this date
    # @option params [Date, String] :enddate Date or ISO formatted string to
    #   restrict data sets to those with data before this date
    # @option params [String] :sortfield ('id') Accepts string values 'id', 'name,
    #   'mindate', 'maxdate', and 'datacoverage' to sort data before being returned
    # @option params [String] :sortorder ('asc') Accepts 'asc' or 'desc' for sort order
    # @option params [Integer] :limit Set a limit to the amount of records returned
    # @option params [Integer] :offset (0) Used to offset the result list
    # @return [Array<Location>] An array of {Location} objects
    def self.where(params = {})
      data = super(@@endpoint, params)
      if data && data.any?
        data.collect {|item| self.new item['id'], item['name'], item['datacoverage'], Date.parse(item['mindate']), Date.parse(item['maxdate'])}
      else
        []
      end
    end
  end
end
