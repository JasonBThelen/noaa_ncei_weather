require 'helper'

class TestData < Test::Unit::TestCase
  def setup
    super
  end

  def test_where
    sleep 1
    data = NoaaNceiWeather::Data.where('GHCND', (Date.today - 30).iso8601, (Date.today - 29).iso8601, {limit: 5})
    assert data.kind_of?(Array), "where is not returning an array"
    assert data.first.kind_of?(NoaaNceiWeather::Data), "returned array contains objects of the wrong type"
  end

  def test_where_dates
    date = (Date.today - 30)
    sleep 1
    data = NoaaNceiWeather::Data.where('GHCND', date.iso8601, date.iso8601, {limit: 5})
    assert_block do
      data.all? {|item| item.date.to_date == date }
    end
  end

  def test_date_large_range
    date_start = Date.today - 400
    date_end = Date.today - 10
    sleep 1
    data = NoaaNceiWeather::Data.where('GHCND', date_start, date_end, {stationid: 'GHCND:USC00505464'})
    assert data.first.date.to_date == date_start, "first record returned should be from startdate"
    assert data.last.date.to_date == date_end, "last record returned should be from enddate"
    sleep 1
    data = NoaaNceiWeather::Data.where('GHCND', date_start, date_end, {datatypeid: 'PRCP', stationid: 'GHCND:USC00505464', limit: 365})
    assert_equal data.count, 365, "getting a different count than set limit"
  end

  def test_where_object_params
    date = (Date.today - 30).iso8601
    sleep 1
    ds = NoaaNceiWeather::Dataset.find('GHCND')
    sleep 1
    data = NoaaNceiWeather::Data.where(ds, date, date, limit: 5)
    assert data.kind_of?(Array), "where is not returning an array"
    assert_equal data.first.class, NoaaNceiWeather::Data, "returned array contains objects of the wrong type"
  end

  def test_where_no_results
    date = (Date.today - 30).iso8601
    sleep 1
    # refute data.any?, "invalid parameter should result in empty array"
    assert_raises RestClient::InternalServerError do
      NoaaNceiWeather::Data.where('INVALID', date, date, limit: 5)
    end
  end

  def test_properties
    date = (Date.today - 30).iso8601
    sleep 1
    ds = NoaaNceiWeather::Dataset.find('GHCND')
    sleep 1
    data = NoaaNceiWeather::Data.where(ds, date, date, {limit: 1}).first
    variables = data.instance_variables
    assert_block do
      variables.all? {|var| data.instance_variable_get(var)}
    end
  end


end
