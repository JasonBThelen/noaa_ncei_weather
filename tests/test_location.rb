require 'helper'

class TestLocation < Test::Unit::TestCase
  def setup
    super
  end

  test "all should return an array of objects" do
    data = NoaaNceiWeather::Location.all
    assert_not_nil data, "data category .all class method returning nil"
    assert data.kind_of?(Array), "data category .all is returning an empty array"
    assert_equal data.first.class, NoaaNceiWeather::Location, "Object returned is not of the correct type"
  end

  test "first should return one object" do
    data = NoaaNceiWeather::Location.first
    assert_equal data.class, NoaaNceiWeather::Location, "Object returned is not of the correct type"
  end

  test "object should have all it's properties" do
    data = NoaaNceiWeather::Location.first
    variables = data.instance_variables
    assert_block do
      variables.all? {|var| data.instance_variable_get(var)}
    end
  end

  test "find should return one object with same id as specified" do
    data = NoaaNceiWeather::Location.first
    single = NoaaNceiWeather::Location.find(data.id)
    assert_equal single.class, NoaaNceiWeather::Location, "Object returned is not op the correct type"
    assert_equal single.id, data.id, "find did not return the correct record"
  end

  test "find_by_zip should return a location with the correct id" do
    single = NoaaNceiWeather::Location.find_by_zip('99645') #Good ole' Alaska
    assert_equal single.class, NoaaNceiWeather::Location, "Object returned is not of the correct type"
    assert_equal single.id, 'ZIP:99645', "object returned has the wrong id"
  end

  test "where should pass params and affect return data" do
    data = NoaaNceiWeather::Location.where(limit: 5)
    assert_equal data.length, 5, "limit param is not being passed to api through where method"
    data1 = NoaaNceiWeather::Location.where(limit: 5, offset: 5)
    assert_not_equal data.first.id, data1.first.id, "offset param is not being passed to api through where method"
    assert_equal data.last.id, data1.first.id, "offset param is not being passed to api through where method"
  end

  test "where should pass sort params and affect return data" do
    data = NoaaNceiWeather::Location.where(sortfield: 'id', sortorder: 'desc')
    assert data[0].id > data[1].id, "sortfield and sortorder params not being passed to api"
  end

  test "data_sets method should return an array of dataset objects" do
    single = NoaaNceiWeather::Location.first
    relation = single.data_sets
    assert relation.kind_of?(Array), "data_sets method is not returning an array"
    assert_equal relation.first.class, NoaaNceiWeather::Dataset, "objects returned are not of correct type"
  end

  test "data_categories method should return an array of data_category objects" do
    single = NoaaNceiWeather::Location.first
    relation = single.data_categories
    assert relation.kind_of?(Array), "data_sets method is not returning an array"
    assert_equal relation.first.class, NoaaNceiWeather::DataCategory, "objects returned are not of correct type"
  end

  test "data_types method should return an array of data_type objects" do
    single = NoaaNceiWeather::Location.first
    relation = single.data_types
    assert relation.kind_of?(Array), "data_sets method is not returning an array"
    assert_equal relation.first.class, NoaaNceiWeather::DataType, "objects returned are not of correct type"
  end

  test "stations method should return an array of station objects" do
    single = NoaaNceiWeather::Location.first
    relation = single.stations
    assert relation.kind_of?(Array), "data_sets method is not returning an array"
    assert_equal relation.first.class, NoaaNceiWeather::Station, "objects returned are not of correct type"
  end

end
