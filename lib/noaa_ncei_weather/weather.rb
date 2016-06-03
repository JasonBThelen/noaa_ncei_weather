module NoaaNceiWeather
  class Weather
    def self.all
      self.where
    end
    def self.where(endpoint, params = {})
      data = Connection.request(endpoint, params)['results']
      dslist = []
      data.each do |dataset|
        set = self.new(dataset)
        dslist.push(set)
      end
      return dslist
    end
  end
end
