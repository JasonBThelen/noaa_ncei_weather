require 'helper'

class TestDataset < Test::Unit::TestCase
  def setup
    super
  end

  test "all should return an array of objects" do
    data = NoaaNceiWeather::Dataset.all
    assert_not_nil data, "data category .all class method returning nil"
    assert data.kind_of?(Array), "data category .all is returning an empty array"
    assert_equal data.first.class, NoaaNceiWeather::Dataset, "Object returned is not of the correct type"
  end

  test "first should return one object" do
    data = NoaaNceiWeather::Dataset.first
    assert_equal data.class, NoaaNceiWeather::Dataset, "Object returned is not of the correct type"
  end

  test "object should have all it's properties" do
    data = NoaaNceiWeather::Dataset.first
    variables = data.instance_variables
    assert_block do
      variables.all? {|var| data.instance_variable_get(var)}
    end
  end

  test "where should pass params and affect return data" do
    data = NoaaNceiWeather::Dataset.where(limit: 5)
    assert_equal data.length, 5, "limit param is not being passed to api through where method"
    data1 = NoaaNceiWeather::Dataset.where(limit: 5, offset: 5)
    assert_not_equal data.first.id, data1.first.id, "offset param is not being passed to api through where method"
    assert_equal data.last.id, data1.first.id, "offset param is not being passed to api through where method"
  end

  test "where should pass sort params and affect return data" do
    data = NoaaNceiWeather::Dataset.where(sortfield: 'id', sortorder: 'desc')
    assert data[0].id > data[1].id, "sortfield and sortorder params not being passed to api"
  end

  test "find should return a single object with the queried id" do
    data = NoaaNceiWeather::Dataset.first
    single = NoaaNceiWeather::Dataset.find(data.id)
    assert_equal single.class, NoaaNceiWeather::Dataset, "find not returning correct object type"
    assert_equal single.id, data.id, "find returning object with the wrong id"
  end

  test "data_categories method should return an array of data category objects" do
    single = NoaaNceiWeather::Dataset.first
    relation = single.data_categories
    assert relation.kind_of?(Array), "data_types method is not returning an array"
    assert_equal relation.first.class, NoaaNceiWeather::DataCategory, "objects returned are not of correct type"
  end

  test "data_types method should return an array of data type objects" do
    single = NoaaNceiWeather::Dataset.first
    relation = single.data_types
    assert relation.kind_of?(Array), "data_types method is not returning an array"
    assert_equal relation.first.class, NoaaNceiWeather::DataType, "objects returned are not of correct type"
  end

  test "location_categories method should return an array of location category objects" do
    single = NoaaNceiWeather::Dataset.first
    relation = single.location_categories
    assert relation.kind_of?(Array), "locations method is not returning an array"
    assert_equal relation.first.class, NoaaNceiWeather::LocationCategory, "objects returned are not of correct type"
  end

  test "locations method should return an array of location objects" do
    single = NoaaNceiWeather::Dataset.first
    relation = single.locations
    assert relation.kind_of?(Array), "locations method is not returning an array"
    assert_equal relation.first.class, NoaaNceiWeather::Location, "objects returned are not of correct type"
  end

  test "stations method should return an array of station objects" do
    single = NoaaNceiWeather::Dataset.first
    relation = single.stations
    assert relation.kind_of?(Array), "stations method is not returning an array"
    assert_equal relation.first.class, NoaaNceiWeather::Station, "objects returned are not of correct type"
  end

end
