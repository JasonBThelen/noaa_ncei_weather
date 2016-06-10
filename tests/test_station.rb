require 'helper'

class TestStation < Test::Unit::TestCase
  def setup
    super
  end

  # Removed .all test due to volume of records

  test "first should return one object" do
    sleep 1
    data = NoaaNceiWeather::Station.first
    assert_equal data.class, NoaaNceiWeather::Station, "Object returned is not of the correct type"
  end

  test "object should have all it's properties" do
    sleep 1
    data = NoaaNceiWeather::Station.first
    variables = data.instance_variables
    assert_block do
      variables.all? {|var| data.instance_variable_get(var)}
    end
  end

  test "find should return single object with correct id" do
    sleep 1
    data = NoaaNceiWeather::Station.first
    sleep 1
    single = NoaaNceiWeather::Station.find(data.id)
    assert_equal single.class, NoaaNceiWeather::Station
    assert_equal single.id, data.id
  end

  test "find_by_zip should return an array of objects within that zip" do
    sleep 1
    data = NoaaNceiWeather::Station.find_by_zip("99645")
    assert_block do
      data.any? {|station| station.name.include? "PALMER"}
    end
  end

  test "where should pass params and affect return data" do
    sleep 1
    data = NoaaNceiWeather::Station.where(limit: 5)
    assert_equal data.length, 5, "limit param is not being passed to api through where method"
    sleep 1
    data1 = NoaaNceiWeather::Station.where(limit: 5, offset: 5)
    assert_not_equal data.first.id, data1.first.id, "offset param is not being passed to api through where method"
    assert_equal data.last.id, data1.first.id, "offset param is not being passed to api through where method"
  end

  test "where should pass sort params and affect return data" do
    sleep 1
    data = NoaaNceiWeather::Station.where(sortfield: 'id', sortorder: 'desc', limit: 2)
    assert data[0].id > data[1].id, "sortfield and sortorder params not being passed to api"
  end

  test "data_sets method should return an array of dataset objects" do
    sleep 1
    single = NoaaNceiWeather::Station.first
    sleep 1
    relation = single.data_sets
    assert relation.kind_of?(Array), "data_sets method is not returning an array"
    assert_equal relation.first.class, NoaaNceiWeather::Dataset, "objects returned are not of correct type"
  end

  test "data_categories method should return an array of data_category objects" do
    sleep 1
    single = NoaaNceiWeather::Station.first
    sleep 1
    relation = single.data_categories
    assert relation.kind_of?(Array), "data_sets method is not returning an array"
    assert_equal relation.first.class, NoaaNceiWeather::DataCategory, "objects returned are not of correct type"
  end

  test "data_types method should return an array of data_type objects" do
    sleep 1
    single = NoaaNceiWeather::Station.first
    sleep 1
    relation = single.data_types
    assert relation.kind_of?(Array), "data_sets method is not returning an array"
    assert_equal relation.first.class, NoaaNceiWeather::DataType, "objects returned are not of correct type"
  end

end
