module NoaaNceiWeather
  # Class for querying against the /datacategory endpoint of the NOAA API
  class DataCategory < Weather

    # Endpoint portion of the API URL, appended to the Connection URL for requests
    @@endpoint = 'datacategories'

    # @!attribute [r] id
    #   @return [String] The unique Identifier of the {DataCategory}
    # @!attribute [r] name
    #   @return [String] The descriptive name of the {DataCategory}

    # Finds the {DataType DataTypes} associated with a {DataCategory} object
    #
    # @param params [Hash] Hash of parameters to filter data returned as
    #   documented by {http://www.ncdc.noaa.gov/cdo-web/webservices/v2#dataTypes NOAA}
    # @return [Array<DataType>] Array of the data types associated with this
    #   {DataCategory} instance
    def data_types(params = {})
      params.merge!({datacategoryid: @id})
      DataType.where(params)
    end

    # Finds the {Location}s associated with a {DataCategory} object
    #
    # @param params [Hash] Hash of parameters to filter data, accepts params
    #   documented by {http://www.ncdc.noaa.gov/cdo-web/webservices/v2#locations NOAA}
    # @return [Array<DataType>] Array of the data types associated with this
    #   DataCategory instance
    def locations(params = {})
      params.merge!({datacategoryid: @id})
      Location.where(params)
    end

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

    # Finds a set of {DataCategory DataCategories} based on the parameters given
    #
    # @param params [Hash] Hash of parameters to filter data, any accepted by {http://www.ncdc.noaa.gov/cdo-web/webservices/v2#locationCategories NOAA}.
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
