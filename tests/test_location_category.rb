require 'helper'

class TestLocationCategory < Test::Unit::TestCase
  def setup
    super
  end

  test "all should return an array of objects" do
    data = NoaaNceiWeather::LocationCategory.all
    assert_not_nil data, "data category .all class method returning nil"
    assert data.kind_of?(Array), "data category .all is returning an empty array"
    assert_equal data.first.class, NoaaNceiWeather::LocationCategory, "Object returned is not of the correct type"
  end

  test "first should return one object" do
    data = NoaaNceiWeather::LocationCategory.first
    assert_equal data.class, NoaaNceiWeather::LocationCategory, "Object returned is not of the correct type"
  end

  test "object should have all it's properties" do
    data = NoaaNceiWeather::LocationCategory.first
    variables = data.instance_variables
    assert_block do
      variables.all? {|var| data.instance_variable_get(var)}
    end
  end

  test "where should pass params and affect return data" do
    data = NoaaNceiWeather::LocationCategory.where(limit: 5)
    assert_equal data.length, 5, "limit param is not being passed to api through where method"
    data1 = NoaaNceiWeather::LocationCategory.where(limit: 5, offset: 5)
    assert_not_equal data.first.id, data1.first.id, "offset param is not being passed to api through where method"
    assert_equal data.last.id, data1.first.id, "offset param is not being passed to api through where method"
  end

  test "where should pass sort params and affect return data" do
    data = NoaaNceiWeather::LocationCategory.where(sortfield: 'id', sortorder: 'desc')
    assert data[0].id > data[1].id, "sortfield and sortorder params not being passed to api"
  end

  test "locations method should return an array of location objects" do
    single = NoaaNceiWeather::LocationCategory.first
    relation = single.locations
    assert relation.kind_of?(Array), "locations method is not returning an array"
    assert_equal relation.first.class, NoaaNceiWeather::Location, "objects returned are not of correct type"
  end

end
