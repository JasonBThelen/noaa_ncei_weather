module NoaaNceiWeather

  # Class for querying against the /datacategory endpoint of the NOAA API
  class LocationCategory < Weather

    # Endpoint portion of the API URL, appended to the Connection URL for requests
    @@endpoint = 'locationcategories'

    # @!attribute [r] id
    #   @return [String] The unique Identifier
    # @!attribute [r] name
    #   @return [String] The descriptive name

    # Retrieves the {Location Locations} associated with the {LocationCategory}.
    #   {LocationCategory} has a one to many relationship with {Loction}.
    #
    # @param params [Hash] See {Location#where} for valid key/values.
    # @return [Array<Location>] Array of the {Location} objects associated with
    #   the instance of {LocationCategory}
    def locations(params = {})
      params.merge!({locationcategoryid: @id})
      Location.where(params)
    end

    # Finds a specific instance of {LocationCategory} by ID
    #
    # @param id [String] ID of the {LocationCategory} object you want
    # @return [LocationCategory] An instance of {LocationCategory} with the given ID
    def self.find(id)
      data = super(@@endpoint + "/#{id}")
      if data && data.any?
        self.new data['id'], data['name']
      else
        nil
      end
    end

    # Retrieves a collection of {LocationCategory LocationCategories} based on
    #   the given parameters
    #
    # @param params [Hash] Hash to set filters on the request sent to the NOAA API
    # @option params [String] :datasetid Filter data types by their {DataSet}
    # @option params [DataSet] :dataset Alternative way to pass :datasetid
    # @option params [Date, String] :startdate Date or ISO formmated string to
    #   restrict location categories to those with data after this date
    # @option params [Date, String] :enddate Date or ISO formatted string to
    #   restrict location categories to those with data before this date
    # @option params [String] :sortfield ('id') Accepts string values 'id', 'name,
    #   'mindate', 'maxdate', and 'datacoverage' to sort data before being returned
    # @option params [String] :sortorder ('asc') Accepts 'asc' or 'desc' for sort order
    # @option params [Integer] :limit Set a limit to the amount of records returned
    # @option params [Integer] :offset (0) Used to offset the result list
    # @return [Array<LocationCategory>] An array of {LocationCategory} objects that
    #   match the filters given
    def self.where(params = {})
      data = super(@@endpoint, params)
      if data && data.any?
        data.collect {|item| self.new item['id'], item['name']}
      else
        []
      end
    end

  end
end
