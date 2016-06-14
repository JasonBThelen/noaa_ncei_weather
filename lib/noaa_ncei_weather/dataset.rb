module NoaaNceiWeather

  # Class for querying against the /datacategory endpoint of the NOAA API
  class Dataset < Weather

    # Endpoint portion of the API URL, appended to the Connection URL for requests
    @@endpoint = 'datasets'

    # @!attribute [r] id
    #   @return [String] The unique Identifier, semi-readable
    # @!attribute [r] uid
    #   @return [String] A second unique identifier used by NOAA
    # @!attribute [r] name
    #   @return [String] The descriptive name
    # @!attribute [r] datacoverage
    #   @return [Fixnum] The estimated completeness of data, value between 0 and 1
    # @!attribute [r] mindate
    #   @return [Date] Earliest availability of data in this set
    # @!attribute [r] maxdate
    #   @return [String] Latest availability of data in this set
    attr_reader :uid, :mindate, :maxdate, :datacoverage

    # Creates new {DataType} object
    def initialize(id, uid, name, datacoverage, mindate, maxdate)
      super(id, name)
      @uid = uid
      @datacoverage = datacoverage
      @mindate = mindate
      @maxdate = maxdate
    end

    # Retrieves the {DataCategory DataCategories} that this instance of {Dataset} belongs to.
    #   {Dataset} and {DataCategory} have a many to many relationship.
    #
    # @param params [Hash] Hash of parameters to filter data, any accepted by {http://www.ncdc.noaa.gov/cdo-web/webservices/v2#dataCategories NOAA}
    # @return [Array<DataCategory>] An array of {DataCategory} objects that
    #   belong to this instance of {Dataset}
    def data_categories(params = {})
      params.merge!({datasetid: @id})
      DataCategory.where(params)
    end

    # Retrieves the {DataType DataTypes} associated with this instance of {Dataset}.
    #   {Dataset} and {DataType} have a many to many relationship.
    #
    # @param params [Hash] Hash of parameters to filter data, any accepted by {http://www.ncdc.noaa.gov/cdo-web/webservices/v2#dataTypes NOAA}
    # @return [Array<DataType>] An array of {DataType} objects that this instance
    #   of {Dataset} belongs to
    def data_types(params = {})
      params.merge!({datasetid: @id})
      DataType.where(params)
    end

    # Retrieves the {LocationCategory LocationCategories} associated with this instance of {Dataset}.
    #   {Dataset} and {DataType} have a many to many relationship.
    #
    # @param params [Hash] Hash of parameters to filter data, any accepted by {http://www.ncdc.noaa.gov/cdo-web/webservices/v2#dataCategories NOAA}
    # @return [Array<LocationCategory>] An array of {LocationCategory} objects associated
    #   with this instance of {Dataset}.
    def location_categories(params = {})
      params.merge!({datasetid: @id})
      LocationCategory.where(params)
    end

    # Retrieves the {Location Locations} associated with this instance of {Dataset}.
    #   {Dataset} and {Location} have a many to many relationship.
    #
    # @param params [Hash] Hash of parameters to filter data, any accepted by
    #   {http://www.ncdc.noaa.gov/cdo-web/webservices/v2#locations NOAA}.
    # @return [Array<Location>] An array of {Location} objects associated with
    #   this instance of {Dataset}
    def locations(params = {})
      params.merge!({datasetid: @id})
      Location.where(params)
    end

    # Retrieves the {Station Stations} associated with this instance of {Dataset}.
    # {Dataset} and {Station} have a many to many relationship
    #
    # @param params [Hash] Hash of parameters to filter data, any accepted by
    #   {http://www.ncdc.noaa.gov/cdo-web/webservices/v2#stations NOAA}
    # @return [Array<Station>] An array of {Station} objects associated with this
    #   instance of {Dataset}.
    def stations(params = {})
      params.merge!({datasetid: @id})
      Station.where(params)
    end

    # Finds a specific instance of {DataCategory} by its ID
    #
    # @param id [String] String ID of the resource.
    # @return [Dataset, nil] Instance of {Dataset}, or nil if none found.
    def self.find(id)
      data = super(@@endpoint + "/#{id}")
      if data && data.any?
        self.new data['id'], data['uid'], data['name'], data['datacoverage'], Date.parse(data['mindate']), Date.parse(data['maxdate'])
      else
        nil
      end
    end

    # Finds a set of {Dataset Datasets} based on the parameters given
    #
    # @param params [Hash] Hash of parameters to filter data, any accepted by
    #   {http://www.ncdc.noaa.gov/cdo-web/webservices/v2#datasets NOAA}
    # @return [Array<Dataset>] An array of {Dataset} objects
    def self.where(params = {})
      data = super(@@endpoint, params)
      if data && data.any?
        data.collect { |item| self.new item['id'], item['uid'], item['name'], item['datacoverage'], Date.parse(item['mindate']), Date.parse(item['maxdate']) }
      else
        []
      end
    end
  end
end
