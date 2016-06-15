require 'helper'

class TestDataset < Test::Unit::TestCase
  def setup
    super
  end

  def test_all
    sleep 1
    data = NoaaNceiWeather::Dataset.all
    assert_not_nil data, "data category .all class method returning nil"
    assert data.kind_of?(Array), "data category .all is returning an empty array"
    assert_equal data.first.class, NoaaNceiWeather::Dataset, "Object returned is not of the correct type"
    sleep 1
    total = NoaaNceiWeather::Dataset.request('datasets')['metadata']['resultset']['count']
    assert_equal data.count, total, "all is returning a different amount than the total"
  end

  def test_first
    sleep 1
    data = NoaaNceiWeather::Dataset.first
    assert_equal data.class, NoaaNceiWeather::Dataset, "Object returned is not of the correct type"
  end

  def test_properties
    sleep 1
    data = NoaaNceiWeather::Dataset.first
    variables = data.instance_variables
    assert_block do
      variables.all? {|var| data.instance_variable_get(var)}
    end
  end

  def test_where
    sleep 1
    data = NoaaNceiWeather::Dataset.where(limit: 5)
    assert_equal data.length, 5, "limit param is not being passed to api through where method"
    sleep 1
    data1 = NoaaNceiWeather::Dataset.where(limit: 5, offset: 5)
    assert_not_equal data.first.id, data1.first.id, "offset param is not being passed to api through where method"
    assert_equal data.last.id, data1.first.id, "offset param is not being passed to api through where method"
  end

  def test_where_params
    sleep 1
    data = NoaaNceiWeather::Dataset.where(sortfield: 'id', sortorder: 'desc', limit: 2)
    assert data[0].id > data[1].id, "sortfield and sortorder params not being passed to api"
  end

  def test_where_invalid
    sleep 1
    data = NoaaNceiWeather::Dataset.where(datatypeid: 'INVALID')
    refute data.any?, "invalid parameter values should result in an empty array"
  end

  def test_find
    sleep 1
    data = NoaaNceiWeather::Dataset.first
    sleep 1
    single = NoaaNceiWeather::Dataset.find(data.id)
    assert_equal single.class, NoaaNceiWeather::Dataset, "find not returning correct object type"
    assert_equal single.id, data.id, "find returning object with the wrong id"
  end

  def test_find_invalid
    sleep 1
    data = NoaaNceiWeather::Dataset.find('INVALID')
    assert_nil data, "passing an invalid id to find should result in nil"
  end

  def test_data_categories
    sleep 1
    single = NoaaNceiWeather::Dataset.first
    relation = single.data_categories
    assert relation.kind_of?(Array), "data_types method is not returning an array"
    assert_equal relation.first.class, NoaaNceiWeather::DataCategory, "objects returned are not of correct type"
  end

  def test_data_types
    sleep 1
    single = NoaaNceiWeather::Dataset.first
    relation = single.data_types
    assert relation.kind_of?(Array), "data_types method is not returning an array"
    assert_equal relation.first.class, NoaaNceiWeather::DataType, "objects returned are not of correct type"
  end

  def test_location_categories
    sleep 1
    single = NoaaNceiWeather::Dataset.first
    relation = single.location_categories
    assert relation.kind_of?(Array), "locations method is not returning an array"
    assert_equal relation.first.class, NoaaNceiWeather::LocationCategory, "objects returned are not of correct type"
  end

  def test_locations
    sleep 1
    single = NoaaNceiWeather::Dataset.first
    relation = single.locations
    assert relation.kind_of?(Array), "locations method is not returning an array"
    assert_equal relation.first.class, NoaaNceiWeather::Location, "objects returned are not of correct type"
  end

  def test_stations
    sleep 1
    single = NoaaNceiWeather::Dataset.first
    relation = single.stations
    assert relation.kind_of?(Array), "stations method is not returning an array"
    assert_equal relation.first.class, NoaaNceiWeather::Station, "objects returned are not of correct type"
  end

end
