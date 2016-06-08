module NoaaNceiWeather
  module Connection
    @@url = 'http://www.ncdc.noaa.gov/cdo-web/api/v2/'
    @@token = ''

    def self.token=(token)
      @@token = token
    end

    def self.request(endpoint, params = {})
      url = @@url + endpoint
      response = RestClient::Request.execute(method: 'get', url: url, headers: {token: @@token, params: params})
      JSON.parse(response.body)
    end
  end
end
