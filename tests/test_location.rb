require 'helper'

class TestLocation < Test::Unit::TestCase
  def setup
    super
  end

  # Removed .all test due to the volume of records it would return

  def test_first
    sleep 1
    data = NoaaNceiWeather::Location.first
    assert_equal data.class, NoaaNceiWeather::Location, "Object returned is not of the correct type"
  end

  def test_properties
    sleep 1
    data = NoaaNceiWeather::Location.first
    variables = data.instance_variables
    assert_block do
      variables.all? {|var| data.instance_variable_get(var)}
    end
  end

  def test_find
    sleep 1
    data = NoaaNceiWeather::Location.first
    sleep 1
    single = NoaaNceiWeather::Location.find(data.id)
    assert_equal single.class, NoaaNceiWeather::Location, "Object returned is not op the correct type"
    assert_equal single.id, data.id, "find did not return the correct record"
  end

  def test_find_invalid
    sleep 1
    data = NoaaNceiWeather::Location.find('INVALID')
    assert_nil data, "passing an invalid id to find should result in nil"
  end

  def test_find_by_zip
    sleep 1
    single = NoaaNceiWeather::Location.find_by_zip('99645') #Good ole' Alaska
    assert_equal single.class, NoaaNceiWeather::Location, "Object returned is not of the correct type"
    assert_equal single.id, 'ZIP:99645', "object returned has the wrong id"
  end

  def test_where
    sleep 1
    data = NoaaNceiWeather::Location.where(limit: 5)
    assert_equal data.length, 5, "limit param is not being passed to api through where method"
    sleep 1
    data1 = NoaaNceiWeather::Location.where(limit: 5, offset: 5)
    assert_not_equal data.first.id, data1.first.id, "offset param is not being passed to api through where method"
    assert_equal data.last.id, data1.first.id, "offset param is not being passed to api through where method"
  end

  def test_where_limit
    sleep 1
    data = NoaaNceiWeather::Location.where(limit: 1005) #there are more than 1005 records here
    assert_equal data.count, 1005, "limit is not returning correct amount of records"
  end

  def test_where_params
    sleep 1
    data = NoaaNceiWeather::Location.where(sortfield: 'id', sortorder: 'desc', limit: 2)
    assert data[0].id > data[1].id, "sortfield and sortorder params not being passed to api"
  end

  def test_where_invalid
    sleep 1
    data = NoaaNceiWeather::Location.where(datasetid: 'INVALID')
    refute data.any?, "invalid parameter values should result in an empty array"
  end

  def test_data_sets
    sleep 1
    single = NoaaNceiWeather::Location.first
    sleep 1
    relation = single.data_sets
    assert relation.kind_of?(Array), "data_sets method is not returning an array"
    assert_equal relation.first.class, NoaaNceiWeather::Dataset, "objects returned are not of correct type"
  end

  def test_data_categories
    sleep 1
    single = NoaaNceiWeather::Location.first
    sleep 1
    relation = single.data_categories
    assert relation.kind_of?(Array), "data_sets method is not returning an array"
    assert_equal relation.first.class, NoaaNceiWeather::DataCategory, "objects returned are not of correct type"
  end

  def test_data_types
    sleep 1
    single = NoaaNceiWeather::Location.first
    sleep 1
    relation = single.data_types
    assert relation.kind_of?(Array), "data_sets method is not returning an array"
    assert_equal relation.first.class, NoaaNceiWeather::DataType, "objects returned are not of correct type"
  end

  def test_stations
    sleep 1
    single = NoaaNceiWeather::Location.first
    sleep 1
    relation = single.stations
    assert relation.kind_of?(Array), "data_sets method is not returning an array"
    assert_equal relation.first.class, NoaaNceiWeather::Station, "objects returned are not of correct type"
  end

  def test_location_category
    sleep 1
    single = NoaaNceiWeather::Location.first
    sleep 1
    relation = single.location_category
    assert_not_nil relation, "should be returning an instance"
    assert_equal relation.class, NoaaNceiWeather::LocationCategory, "should have a single LocationCategory"
  end

end
