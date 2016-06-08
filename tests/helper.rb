require './lib/noaa_ncei_weather'
require 'test/unit'

class Test::Unit::TestCase

  # Set your own token here for running tests against the web api
  def setup
    NoaaNceiWeather::Connection.token = ''
  end

end
