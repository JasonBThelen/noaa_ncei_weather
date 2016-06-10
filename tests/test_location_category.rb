require 'helper'

class TestLocationCategory < Test::Unit::TestCase
  def setup
    super
  end

  def test_all
    sleep 1
    data = NoaaNceiWeather::LocationCategory.all
    assert_not_nil data, "data category .all class method returning nil"
    assert data.kind_of?(Array), "data category .all is returning an empty array"
    assert_equal data.first.class, NoaaNceiWeather::LocationCategory, "Object returned is not of the correct type"
    sleep 1
    total = NoaaNceiWeather::Connection.request('locationcategories')['metadata']['resultset']['count']
    assert_equal data.count, total, "all is returning a different amount than the total"
end

  def test_first
    sleep 1
    data = NoaaNceiWeather::LocationCategory.first
    assert_equal data.class, NoaaNceiWeather::LocationCategory, "Object returned is not of the correct type"
  end

  def test_properties
    sleep 1
    data = NoaaNceiWeather::LocationCategory.first
    variables = data.instance_variables
    assert_block do
      variables.all? {|var| data.instance_variable_get(var)}
    end
  end

  def test_where
    sleep 1
    data = NoaaNceiWeather::LocationCategory.where(limit: 5)
    assert_equal data.length, 5, "limit param is not being passed to api through where method"
    sleep 1
    data1 = NoaaNceiWeather::LocationCategory.where(limit: 5, offset: 5)
    assert_not_equal data.first.id, data1.first.id, "offset param is not being passed to api through where method"
    assert_equal data.last.id, data1.first.id, "offset param is not being passed to api through where method"
  end

  def test_where_params
    sleep 1
    data = NoaaNceiWeather::LocationCategory.where(sortfield: 'id', sortorder: 'desc', limit: 2)
    assert data[0].id > data[1].id, "sortfield and sortorder params not being passed to api"
  end

  def test_locations
    sleep 1
    single = NoaaNceiWeather::LocationCategory.first
    sleep 1
    relation = single.locations
    assert relation.kind_of?(Array), "locations method is not returning an array"
    assert_equal relation.first.class, NoaaNceiWeather::Location, "objects returned are not of correct type"
  end

end
