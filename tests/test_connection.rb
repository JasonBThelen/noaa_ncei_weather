require 'helper'

class TestConnection < Test::Unit::TestCase
  def setup
    super
  end

  test "should throw exception if token not present" do
    NoaaNceiWeather::Connection.token = ''
    assert_raise RestClient::BadRequest do
      NoaaNceiWeather::Connection.request('locationcategories')
    end
  end
end
