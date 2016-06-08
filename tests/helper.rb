require './lib/noaa_ncei_weather'
require 'test/unit'

class TestHelper

  # Set your own token here for running tests against the web api
  def self.connection_setup
    NoaaNceiWeather::Connection.token = ''
  end

end
