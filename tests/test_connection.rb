require './lib/noaa_ncei_weather'
require 'test/unit'

class TestConnection < Test::Unit::TestCase

  test "should throw exception if token not present" do
    NoaaNceiWeather::Connection.token = ''
    assert_raise RestClient::BadRequest do
      NoaaNceiWeather::Connection.request('locationcategories')
    end
  end
end
