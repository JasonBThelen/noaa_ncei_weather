module NoaaNceiWeather
  class Data
    extend Connection
    @@endpoint = 'data'
    attr_reader :date, :datatype, :station, :attributes, :value
    def initialize(date, datatype, station, attributes, value)
      @date = date
      @datatype = datatype
      @station = station
      @attributes = attributes
      @value = value
    end

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
      output.collect {|item| self.new Date.parse(item['date']), item['datatype'], item['station'], item['attributes'], item['value']}
    end
  end
end
