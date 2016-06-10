require 'helper'

class TestConnection < Test::Unit::TestCase
  def setup
    super
  end

  def test_request_without_token
    NoaaNceiWeather::Connection.token = ''
    assert_raise RestClient::BadRequest do
      NoaaNceiWeather::Connection.request('locationcategories')
    end
  end
end
