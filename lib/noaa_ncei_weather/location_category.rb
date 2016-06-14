module NoaaNceiWeather
  class LocationCategory < Weather
    @@endpoint = 'locationcategories'
    attr_reader :name, :id

    def locations(params = {})
      params.merge!({locationcategoryid: @id})
      Location.where(params)
    end

    def self.find(id)
      data = super(@@endpoint + "/#{id}")
      if data && data.any?
        self.new data['id'], data['name']
      else
        nil
      end
    end

    def self.where(params = {})
      data = super(@@endpoint, params)
      if data && data.any?
        data.collect {|item| self.new item['id'], item['name']}
      else
        []
      end
    end

  end
end
