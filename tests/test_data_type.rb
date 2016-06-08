require 'helper'

class TestDataType < Test::Unit::TestCase
  def setup
    super
  end

  test ".all should return an array of objects" do
    data = NoaaNceiWeather::DataType.all
    assert_not_nil data, "data type .all class method returning nil"
    assert data.kind_of?(Array), "data type .all is returning an empty array"
    assert_equal data.first.class, NoaaNceiWeather::DataType, "Object returned is not of the correct type"
  end

  test ".first should return one object" do
    data = NoaaNceiWeather::DataType.first
    assert_equal data.class, NoaaNceiWeather::DataType, "Object returned is not of the correct type"
  end

  test ".where should pass params and affect return data" do
    data = NoaaNceiWeather::DataType.where(limit: 5)
    assert_equal data.length, 5, "limit param is not being passed to api through where method"
    data1 = NoaaNceiWeather::DataType.where(limit: 5, offset: 5)
    assert_not_equal data.first.id, data1.first.id, "offset param is not being passed to api through where method"
    assert_equal data.last.id, data1.first.id, "offset param is not being passed to api through where method"
  end

  test "where should pass sort params and affect return data" do
    data = NoaaNceiWeather::DataType.where(sortfield: 'id', sortorder: 'desc')
    assert data[0].id > data[1].id, "sortfield and sortorder params not being passed to api"
  end

  test "find should return a single object with the queried id" do
    data = NoaaNceiWeather::DataType.first
    dc = NoaaNceiWeather::DataType.find(data.id)
    assert_equal dc.class, NoaaNceiWeather::DataType, "find not returning correct object type"
    assert_equal dc.id, data.id, "find returning object with the wrong id"
  end

  test ".dataset method should return a dataset object" do
    dt = NoaaNceiWeather::DataType.first
    ds = dt.dataset
    assert_equal ds.class, NoaaNceiWeather::Dataset, "object returned are not of correct type"
  end

  test "stations method should return an array of station objects" do
    dt = NoaaNceiWeather::DataType.first
    sts = dt.stations
    assert sts.kind_of?(Array), "stations method is not returning an array"
    assert_equal sts.first.class, NoaaNceiWeather::Station, "objects returned are not of correct type"
  end

end
