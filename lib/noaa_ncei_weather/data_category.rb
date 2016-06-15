module NoaaNceiWeather

  # Class for querying against the /datacategory endpoint of the NOAA API
  class DataCategory < Weather

    # Endpoint portion of the API URL, appended to the Connection URL for requests
    @@endpoint = 'datacategories'

    # @!attribute [r] id
    #   @return [String] The unique Identifier of the {DataCategory}
    # @!attribute [r] name
    #   @return [String] The descriptive name of the {DataCategory}

    # Retrieves the {DataType DataTypes} associated with a {DataCategory} object
    # {DataCategory} has a one to many relationship with {DataType} (in rare
    # cases a DataType may belong to more than one DataCategory)
    #
    # @param params [Hash] See {DataType.where} for valid param key/values
    # @return [Array<DataType>] Array of the data types associated with this
    #   {DataCategory} instance
    def data_types(params = {})
      params.merge!({datacategoryid: @id})
      DataType.where(params)
    end

    # Retrieves the {Location Locations} associated with a {DataCategory} object.
    # {Location} and {DataCategory} have a many to many relationship.
    #
    # @param params [Hash] See {Location.where} for valid param key/values
    # @return [Array<DataType>] Array of the data types associated with this
    #   DataCategory instance
    def locations(params = {})
      params.merge!({datacategoryid: @id})
      Location.where(params)
    end

    # Retrieves the {Station Stations} associated with a {DataCategory} object
    # {Station} and {DataCategory} have a many to many relationship.
    #
    # @param params [Hash] See {Station.where} for valid param key/values
    # @return [Array<DataType>] Array of the data types associated with this
    #   DataCategory instance
    def stations(params = {})
      params.merge!({datacategoryid: @id})
      Station.where(params)
    end

    # Finds a specific instance of {DataCategory} by its ID
    #
    # @param id [String] String ID of the resource.
    # @return [DataCategory, nil] Instance of {DataCategory}, or nil if none found.
    def self.find(id)
      data = super(@@endpoint + "/#{id}")
      if data && data.any?
        self.new data['id'], data['name']
      else
        nil
      end
    end

    # Retrieves a set of {DataCategory DataCategories} based on the parameters given
    #
    # @param params [Hash] Hash to set filters on the request sent to the NOAA API
    # @option params [String] :datasetid String ID of a {Dataset}
    # @option params [Dataset] :dataset {Dataset} object
    # @option params [String] :locationid String ID of a {Location}
    # @option params [Location] :location {Location} object
    # @option params [String] :stationid String ID of a {Station}
    # @option params [Station] :station {Station} object
    # @option params [String] :sortfield ('id') Accepts string values 'id', 'name,
    #   'mindate', 'maxdate', and 'datacoverage' to sort data before being returned
    # @option params [String] :sortorder ('asc') Accepts 'asc' or 'desc' for sort order
    # @option params [Integer] :limit Set a limit to the amount of records returned
    # @option params [Integer] :offset (0) Used to offset the result list
    # @return [Array<DataCategory>] Array of {DataCategory} objects that match the filter.
    def self.where(params = {})
      data = super(@@endpoint, params)
      if data && data.any?
        data.collect { |item| self.new(item['id'], item['name']) }
      else
        []
      end
    end
  end
end
