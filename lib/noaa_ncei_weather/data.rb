module NoaaNceiWeather
  class Data
    @@endpoint = 'data'
    attr_reader :date, :datatype, :station, :attributes, :value
    def initialize(params)
      @date = Date.parse(params['date'])
      @datatype = params['datatype']
      @station = params['station']
      @attributes = params['attributes']
      @value = params['value']
    end


    def self.query(datasetid, startdate, enddate, params = {})
      datasetid = datasetid.id if datasetid.respond_to?(:id)
      params.merge!({datasetid: datasetid, startdate: startdate, enddate: enddate})
      Weather.parse_params(params)
      data = Connection.request(@@endpoint, params)['results']
      dslist = data.collect { |item| self.new(item) } if data && data.any?
      return dslist || []
    end
  end
end
