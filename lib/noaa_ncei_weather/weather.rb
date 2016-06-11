module NoaaNceiWeather
  class Weather
    def self.all
      self.where
    end

    def self.find(endpoint)
      data = Connection.request(endpoint)
      if data.any?
        self.new(data)
      else
        nil
      end
    end

    def self.first
      data = self.where(limit: 1)
      if data.any?
        data.first
      else
        nil
      end
    end

    def self.where(endpoint, params = {})
      limit = params[:limit] || Float::INFINITY
      params = self.parse_params(params)
      output = []
      begin
        response = Connection.request(endpoint, params)
        break unless response.any?
        meta = response['metadata']['resultset']
        output.concat response['results']
        count = meta['offset'] + meta['limit'] - 1
        params[:offset] = count + 1
        params[:limit] = limit - count if (limit - count) < 1000
      end while count < meta['count'] && count < limit && limit > 1000

      dslist = output.collect { |item| self.new(item) } if output && output.any?
      return dslist || []
    end

    def self.parse_params(params)
      # Handle passing of weather objects as parameters for other api queries
      objects = [:dataset, :datatype, :location, :station, :datacategory, :locationcategory]
      objects.each do |object|
        params[(object.to_s + "id").to_sym] = params.delete(object).id if params.has_key?(object)
      end

      # Handle Date, DateTime, or Time parameters
      # Convert to formatted string the api is expecting
      dates = [:startdate, :enddate]
      dates.each do |date|
        params[date] = params[date].iso8601 if params[date].respond_to?(:iso8601)
      end

      # Prep for handling requests for over the 1k NOAA limit
      params[:limit] = 1000 unless params[:limit] && params[:limit] < 1000

      #return modified params
      params
    end
  end
end
