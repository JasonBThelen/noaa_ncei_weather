require 'helper'

class TestDataCategory < Test::Unit::TestCase
  def setup
    super
  end

  test "all should return an array of objects" do
    sleep(1)
    data = NoaaNceiWeather::DataCategory.all
    assert_not_nil data, "data category .all class method returning nil"
    assert data.kind_of?(Array), "data category .all is returning an empty array"
    assert_equal data.first.class, NoaaNceiWeather::DataCategory, "Object returned is not of the correct type"
    sleep 1
    total = NoaaNceiWeather::Connection.request('datacategories')['metadata']['resultset']['count']
    assert_equal data.count, total, "all is returning a different amount than the total"
  end

  test "first should return one object" do
    sleep 1
    data = NoaaNceiWeather::DataCategory.first
    assert_equal data.class, NoaaNceiWeather::DataCategory, "Object returned is not of the correct type"
  end

  test "object should have all it's properties" do
    sleep 1
    data = NoaaNceiWeather::DataCategory.first
    variables = data.instance_variables
    assert_block do
      variables.all? {|var| data.instance_variable_get(var)}
    end
  end

  test "where should pass params and affect return data" do
    sleep 1
    data = NoaaNceiWeather::DataCategory.where(limit: 5)
    assert_equal data.length, 5, "limit param is not being passed to api through where method"
    sleep 1
    data1 = NoaaNceiWeather::DataCategory.where(limit: 5, offset: 5)
    assert_not_equal data.first.id, data1.first.id, "offset param is not being passed to api through where method"
    assert_equal data.last.id, data1.first.id, "offset param is not being passed to api through where method"
  end

  test "where should take objects as params" do
    sleep 1
    datatype = NoaaNceiWeather::DataType.first
    sleep 1
    data0 = NoaaNceiWeather::DataCategory.where(datatypeid: datatype.id, limit: 1)
    sleep 1
    data1 = NoaaNceiWeather::DataCategory.where(datatype: datatype, limit: 1)
    assert_equal data0.first.id, data1.first.id, "param passed object is not being passed to api correctly"
  end

  test "where should pass sort params and affect return data" do
    sleep 1
    data = NoaaNceiWeather::DataCategory.where(sortfield: 'id', sortorder: 'desc', limit: 2)
    assert data[0].id > data[1].id, "sortfield and sortorder params not being passed to api"
  end

  test "where should return all of the records if limit is greater" do
    sleep 1
    data = NoaaNceiWeather::DataCategory.where(limit: 200)
    sleep 1
    total = NoaaNceiWeather::Connection.request('datacategories')['metadata']['resultset']['count']
    assert_equal data.count, total, "setting limit above total records is returning something other than the total number of records"

  end

  test "find should return a single object with the queried id" do
    sleep 1
    data = NoaaNceiWeather::DataCategory.first
    sleep 1
    dc = NoaaNceiWeather::DataCategory.find(data.id)
    assert_equal dc.class, NoaaNceiWeather::DataCategory, "find not returning correct object type"
    assert_equal dc.id, data.id, "find returning object with the wrong id"
  end

  test "data_types method should return an array of data type objects" do
    sleep 1
    dc = NoaaNceiWeather::DataCategory.first
    dts = dc.data_types
    assert dts.kind_of?(Array), "data_types method is not returning an array"
    assert_equal dts.first.class, NoaaNceiWeather::DataType, "objects returned are not of correct type"
  end

  test "locations method should return an array of location objects" do
    sleep 1
    dc = NoaaNceiWeather::DataCategory.first
    lcs = dc.locations
    assert lcs.kind_of?(Array), "locations method is not returning an array"
    assert_equal lcs.first.class, NoaaNceiWeather::Location, "objects returned are not of correct type"
  end

  test "stations method should return an array of station objects" do
    sleep 1
    dc = NoaaNceiWeather::DataCategory.first
    sts = dc.stations
    assert sts.kind_of?(Array), "stations method is not returning an array"
    assert_equal sts.first.class, NoaaNceiWeather::Station, "objects returned are not of correct type"
  end

end
