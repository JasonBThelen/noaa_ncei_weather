require './lib/noaa_ncei_weather'
require 'test/unit'

class TestWeather < Test::Unit::TestCase

  def test_sample
    assert_equal(4, 2+2)
  end
end
