module NoaaNceiWeather
  class Weather
    def self.all
      self.where
    end
    
    def self.where(endpoint, params = {})
      data = Connection.request(endpoint, params)['results']
      dslist = []
      if data && data.any?
        data.each do |dataset|
          set = self.new(dataset)
          dslist.push(set)
        end
      end
      return dslist
    end

    def self.first
      self.where(limit: 1).first
    end
  end
end
