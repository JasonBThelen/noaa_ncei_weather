require './lib/noaa_ncei_weather'
require 'test/unit'

class TestData < Test::Unit::TestCase

  def setup
    NoaaNceiWeather::Connection.token = 'yhFqitYUoRXgsSyUVhQCzflGvXUxeocq'
  end

  test "query should return an array of data objects" do
    data = NoaaNceiWeather::Data.query('GHCND', (Date.today - 30).iso8601, (Date.today - 29).iso8601)
    assert data.kind_of?(Array), "query is not returning an array"
    assert data.first.kind_of?(NoaaNceiWeather::Data), "returned array contains objects of the wrong type"
  end

  test "query should return records within date range given" do
    date = (Date.today - 30).iso8601
    data = NoaaNceiWeather::Data.query('GHCNDMS', date , date)
    assert_block do
      data.all? {|item| Date.parse(item.date) == Date.parse(date) }
    end
  end
end
