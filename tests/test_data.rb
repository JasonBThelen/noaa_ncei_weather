require 'helper'

class TestData < Test::Unit::TestCase
  def setup
    super
  end

  def test_query
    sleep 1
    data = NoaaNceiWeather::Data.query('GHCND', (Date.today - 30).iso8601, (Date.today - 29).iso8601)
    assert data.kind_of?(Array), "query is not returning an array"
    assert data.first.kind_of?(NoaaNceiWeather::Data), "returned array contains objects of the wrong type"
  end

  def test_query_dates
    date = (Date.today - 30).iso8601
    sleep 1
    data = NoaaNceiWeather::Data.query('GHCNDMS', date , date, limit: 5)
    assert_block do
      data.all? {|item| Date.parse(item.date) == Date.parse(date) }
    end
  end

  def test_query_object_params
    date = (Date.today - 30).iso8601
    sleep 1
    ds = NoaaNceiWeather::Dataset.find('GHCND')
    sleep 1
    data = NoaaNceiWeather::Data.query(ds, date, date, limit: 5)
    assert data.kind_of?(Array), "query is not returning an array"
    assert_equal data.first.class, NoaaNceiWeather::Data, "returned array contains objects of the wrong type"
  end

  def test_properties
    date = (Date.today - 30).iso8601
    sleep 1
    ds = NoaaNceiWeather::Dataset.find('GHCND')
    sleep 1
    data = NoaaNceiWeather::Data.query(ds, date, date, {limit: 1}).first
    variables = data.instance_variables
    assert_block do
      variables.all? {|var| data.instance_variable_get(var)}
    end
  end


end
