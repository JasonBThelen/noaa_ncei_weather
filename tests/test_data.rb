require 'helper'

class TestData < Test::Unit::TestCase
  def setup
    super
  end

  test "query should return an array of data objects" do
    data = NoaaNceiWeather::Data.query('GHCND', (Date.today - 30).iso8601, (Date.today - 29).iso8601)
    assert data.kind_of?(Array), "query is not returning an array"
    assert data.first.kind_of?(NoaaNceiWeather::Data), "returned array contains objects of the wrong type"
  end

  test "query should return records within date range given" do
    date = (Date.today - 30).iso8601
    data = NoaaNceiWeather::Data.query('GHCNDMS', date , date)
    assert_block do
      data.all? {|item| Date.parse(item.date) == Date.parse(date) }
    end
  end

  test "query should work when passing a dataset object" do
    date = (Date.today - 30).iso8601
    ds = NoaaNceiWeather::Dataset.find('GHCND')
    data = NoaaNceiWeather::Data.query(ds, date, date)
    assert data.kind_of?(Array), "query is not returning an array"
    assert_equal data.first.class, NoaaNceiWeather::Data, "returned array contains objects of the wrong type"
  end

  test "object should have all it's properties" do
    date = (Date.today - 30).iso8601
    ds = NoaaNceiWeather::Dataset.find('GHCND')
    data = NoaaNceiWeather::Data.query(ds, date, date, {limit: 1}).first
    variables = data.instance_variables
    assert_block do
      variables.all? {|var| data.instance_variable_get(var)}
    end
  end


end
