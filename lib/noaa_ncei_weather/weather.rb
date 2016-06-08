module NoaaNceiWeather
  class Weather
    def self.all
      self.where
    end

    def self.find(endpoint)
      data = Connection.request(endpoint)
      self.new(data)
    end

    def self.first
      self.where(limit: 1).first
    end

    def self.where(endpoint, params = {})
      params = self.parse_params(params)
      data = Connection.request(endpoint, params)['results']
      dslist = data.collect { |item| self.new(item) } if data && data.any?
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

      #return modified params
      params
    end
  end
end
