require './lib/noaa_ncei_weather'
require 'test/unit'
require './tests/env.rb' if File.exist?('./tests/env.rb')

class Test::Unit::TestCase

  # Set your own token here for running tests against the web api
  def setup
    NoaaNceiWeather::Connection.token = ENV['NOAA_TOKEN']
  end

end
