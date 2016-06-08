require './lib/noaa_ncei_weather'
require 'test/unit'

class TestDataCategory < Test::Unit::TestCase

  def setup
    NoaaNceiWeather::Connection.token = 'yhFqitYUoRXgsSyUVhQCzflGvXUxeocq'
  end

  test "all should return an array of objects" do
    data = NoaaNceiWeather::DataCategory.all
    assert_not_nil data, "data category .all class method returning nil"
    assert data.kind_of?(Array), "data category .all is returning an empty array"
    assert_equal data.first.class, NoaaNceiWeather::DataCategory, "Object returned is not of the correct type"
  end

  test "first should return one object" do
    data = NoaaNceiWeather::DataCategory.first
    assert_equal data.class, NoaaNceiWeather::DataCategory, "Object returned is not of the correct type"
  end

  test "where should pass params and affect return data" do
    data = NoaaNceiWeather::DataCategory.where(limit: 5)
    assert_equal data.length, 5, "limit param is not being passed to api through where method"
    data1 = NoaaNceiWeather::DataCategory.where(limit: 5, offset: 5)
    assert_not_equal data.first.id, data1.first.id, "offset param is not being passed to api through where method"
    assert_equal data.last.id, data1.first.id, "offset param is not being passed to api through where method"
  end

  test "where should pass sort params and affect return data" do
    data = NoaaNceiWeather::DataCategory.where(sortfield: 'id', sortorder: 'desc')
    assert data[0].id > data[1].id, "sortfield and sortorder params not being passed to api"
  end

  test "find should return a single object with the queried id" do
    data = NoaaNceiWeather::DataCategory.first
    dc = NoaaNceiWeather::DataCategory.find(data.id)
    assert_equal dc.class, NoaaNceiWeather::DataCategory, "find not returning correct object type"
    assert_equal dc.id, data.id, "find returning object with the wrong id"
  end

  test "data_types method should return an array of data type objects" do
    dc = NoaaNceiWeather::DataCategory.first
    dts = dc.data_types
    assert dts.kind_of?(Array), "data_types method is not returning an array"
    assert_equal dts.first.class, NoaaNceiWeather::DataType, "objects returned are not of correct type"
  end

  test "locations method should return an array of location objects" do
    dc = NoaaNceiWeather::DataCategory.first
    lcs = dc.locations
    assert lcs.kind_of?(Array), "locations method is not returning an array"
    assert_equal lcs.first.class, NoaaNceiWeather::Location, "objects returned are not of correct type"
  end

  test "stations method should return an array of station objects" do
    dc = NoaaNceiWeather::DataCategory.first
    sts = dc.stations
    assert sts.kind_of?(Array), "stations method is not returning an array"
    assert_equal sts.first.class, NoaaNceiWeather::Station, "objects returned are not of correct type"
  end

end
