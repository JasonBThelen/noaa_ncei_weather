# Namespace for classes and modules that handle requesting data
# from the NOAA NCEI Historical Weather Database
module NoaaNceiWeather

  # Class for querying against the /data endpoint of the
  # {http://www.ncdc.noaa.gov/cdo-web/webservices/v2 NOAA API}. This endpoint
  # gives access to the actual measurements taken.
  class Data
    extend Connection

    # Endpoint portion of the API URL, appended to the Connection URL for requests
    @@endpoint = 'data'

    # @!attribute [r] date
    #   @return [Date] The date this data object was measured
    # @!attribute [r] datatype
    #   @return [String] The type of data measured, ID of DataType
    # @!attribute [r] station
    #   @return [String] The station at which the measurement was taken, ID of {Station}
    # @!attribute [r] value
    #   @return [Numeric] Numeric value of the measurement
    attr_reader :date, :datatype, :station, :attributes, :value

    # Creates a new Data object
    def initialize(date, datatype, station, attributes, value)
      @date = date
      @datatype = datatype
      @station = station
      @attributes = attributes
      @value = value
    end

    # Retrieves a collection of {Data} objects based on the params given.
    #
    # @param datasetid [String] A String ID for a Dataset from the NOAA DB
    # @param startdate [Date] A Date for the first day of data you want
    # @param enddate [Date] A Date for the last day of data you want
    # @param params [Hash] A hash including other params to pass as accepted by the NOAA API
    # @return [Array<Data>] An array of Data objects
    def self.where(datasetid, startdate, enddate, params = {})
      datasetid = datasetid.id if datasetid.respond_to?(:id)
      params[:datasetid] = datasetid

      startdate = Date.parse startdate if startdate.kind_of? String
      enddate = Date.parse enddate if enddate.kind_of? String
      to_date = enddate
      enddate = startdate + 365 if enddate - startdate > 365
      limit = params[:limit] if params[:limit]

      output = []
      begin
        params.merge!({startdate: startdate, enddate: enddate})

        data = super(@@endpoint, params)
        output.concat data
        if limit && output.count >= limit
          output = output[0...limit]
          break
        end
        startdate = enddate + 1
        enddate = startdate + 365
        enddate = to_date if enddate > to_date
        params[:limit] = limit
        params[:offset] = nil
      end while to_date > startdate
      output.collect {|item| self.new DateTime.parse(item['date']), item['datatype'], item['station'], item['attributes'], item['value']}
    end
  end
end
