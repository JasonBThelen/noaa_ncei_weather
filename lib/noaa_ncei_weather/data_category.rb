module NoaaNceiWeather
  class DataCategory < Weather
    @@endpoint = 'datacategories'
    attr_reader :name, :id

    def data_types(params = {})
      params.merge!({datacategoryid: @id})
      DataType.where(params)
    end

    def locations(params = {})
      params.merge!({datacategoryid: @id})
      Location.where(params)
    end

    def stations(params = {})
      params.merge!({datacategoryid: @id})
      Station.where(params)
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
        data.collect { |item| self.new(item['id'], item['name']) }
      else
        []
      end
    end
  end
end
