module NoaaNceiWeather

  # Class for querying against the /datacategory endpoint of the NOAA API
  class Station < Weather

    # Endpoint portion of the API URL, appended to the Connection URL for requests
    @@endpoint = 'stations'

    # @!attribute [r] id
    #   @return [String] The unique Identifier
    # @!attribute [r] name
    #   @return [String] The descriptive name
    # @!attribute [r] datacoverage
    #   @return [Fixnum] The estimated completeness of data, value between 0 and 1
    # @!attribute [r] mindate
    #   @return [Date] Earliest availability of data in this set
    # @!attribute [r] maxdate
    #   @return [String] Latest availability of data in this set
    # @!attribute [r] latitude
    #   @return [Fixnum] Latitude coordinate of the station
    # @!attribute [r] longitude
    #   @return [Fixnum] Longitude coordinate of the station
    # @!attribute [r] elevation
    #   @return [Fixnum] Elevation of the station above sea level
    # @!attribute [r] elevationunit
    #   @return [Fixnum] Unit of measurement for the elevation value
    attr_reader :elevation, :mindate, :maxdate, :latitude, :datacoverage, :elevationunit, :longitude

    # Creates new {Station} object
    def initialize(id, name, datacoverage, mindate, maxdate, elevation, elevationUnit, latitude, longitude)
      super(id, name)
      @datacoverage = datacoverage
      @mindate = mindate
      @maxdate = maxdate
      @elevation = elevation
      @elevationunit = elevationUnit
      @latitude = latitude
      @longitude = longitude
    end

    # Retrieves the {Dataset Datasets} that this instance of {Dataset} has available.
    #   {Station} and {Dataset} have a many to many relationship.
    #
    # @param params [Hash] See {Dataset.where} for valid key/values.
    # @return [Array<Dataset>] An array of {Dataset} objects that
    #   belong to this instance of {Dataset}
    def data_sets(params = {})
      params.merge!({stationid: @id})
      Dataset.where(params)
    end

    # Retrieves the {DataCategory DataCategories} that this instance of {Station} has available.
    #   {Station} and {DataCategory} have a many to many relationship.
    #
    # @param params [Hash] See {DataCategory.where} for valid key/values.
    # @return [Array<DataCategory>] An array of {DataCategory} objects that
    #   belong to this instance of {Station}
    def data_categories(params = {})
      params.merge!({stationid: @id})
      DataCategory.where(params)
    end

    # Retrieves the {DataType DataTypes} that this instance of {Station} has available.
    #   {Station} and {DataType} have a many to many relationship.
    #
    # @param params [Hash] See {DataType.where} for valid key/values.
    # @return [Array<DataType>] An array of {DataType} objects that
    #   belong to this instance of {Station}
    def data_types(params = {})
      params.merge!({stationid: @id})
      DataType.where(params)
    end

    # Finds a specific instance of {Station} by its ID
    #
    # @param id [String] String ID of the resource.
    # @return [Dataset, nil] Instance of {Station}, or nil if none found.
    def self.find(id)
      data = super(@@endpoint + "/#{id}")
      if data && data.any?
        self.new data['id'], data['name'], data['datacoverage'], Date.parse(data['mindate']), Date.parse(data['maxdate']), data['elevation'], data['elevationUnit'], data['latitude'], data['longitude']
      else
        nil
      end
    end

    # Retrieves a collection of {Station} objects within the given zip code
    #
    # @param zip [String] Five digit zip code
    # @return [Array<Station>] Array of {Station} objects in the given zip
    def self.find_by_zip(zip)
      self.where(locationid: "ZIP:#{zip}")
    end

    # Retrieves a set of {Station Stations} based on the parameters given
    #
    # @param params [Hash] Hash to set filters on the request sent to the NOAA API
    # @option params [String] :datasetid String ID of a {Dataset}
    # @option params [DataSet] :dataset {Dataset} object
    # @option params [String] :locationid String ID of a {Location}
    # @option params [Location] :location {Location} object
    # @option params [String] :datacategoryid String ID of a {DataCategory}
    # @option params [DataCategory] :datacategory {DataCategory} object
    # @option params [String] :datatypeid String ID of a {DataType}
    # @option params [DataType] :datatype {DataType} object
    # @option params [String] :extent The desired geographical area to search.
    #   Takes two points as lat1,long1,lat2,long2 as opposite corners of rectangle
    # @option params [Date, String] :startdate Date or ISO formatted string to
    #   restrict data sets to those with data after this date
    # @option params [Date, String] :enddate Date or ISO formatted string to
    #   restrict data sets to those with data before this date
    # @option params [String] :sortfield ('id') Accepts string values 'id', 'name,
    #   'mindate', 'maxdate', and 'datacoverage' to sort data before being returned
    # @option params [String] :sortorder ('asc') Accepts 'asc' or 'desc' for sort order
    # @option params [Integer] :limit Set a limit to the amount of records returned
    # @option params [Integer] :offset (0) Used to offset the result list
    # @return [Array<Station>] An array of {Station} objects
    def self.where(params = {})
      data = super(@@endpoint, params)
      if data && data.any?
        data.collect do |item|
          self.new item['id'], item['name'], item['datacoverage'], Date.parse(item['mindate']), Date.parse(item['maxdate']), item['elevation'], item['elevationUnit'], item['latitude'], item['longitude']
        end
      else
        []
      end
    end
  end
end
