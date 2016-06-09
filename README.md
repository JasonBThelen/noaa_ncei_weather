# NOAA NCEI Weather

Ruby wrapper to the NOAA NCEI Weather API at [ncdc.noaa.gov](http://www.ncdc.noaa.gov/cdo-web/webservices/v2)

Uses [Rest-Client](https://github.com/rest-client/rest-client) to query information from the National Oceanic and Atmospheric Administration Climate Data Web Services API. This provides free access to global historical weather information from around the globe. Many types of weather measurements can be pulled in time frames from the first records to near current (a few days ago).

Use of the API requires the use of a free token. Register for your token on the [request page](http://www.ncdc.noaa.gov/cdo-web/token). You'll need a token to use this gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'noaa_ncei_weather'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install noaa_ncei_weather

## Usage

Start by setting the token

```ruby
NoaaNceiWeather::Connection.token = 'TOKEN'
```

Use the [NOAA](http://www.ncdc.noaa.gov/cdo-web/webservices/v2#gettingStarted) page as a reference for the data available and the paramaters that can be used. This gem provides a class for the data returned by each of the available endpoints.

All of the endpoints (except `Data`) are what I'll call 'organizational' information used to filter down a query to the `Data` class. All of these have class methods for querying against the database.

```ruby
NoaaNceiWeather::LocationCategory.all # Returns a collection of LocationCategory objects
NoaaNceiWeather::LocationCategory.where({limit: 42}) # Returns a collection of LocationCategory objects filtered by the parameters given
NoaaNceiWeather::LocationCategory.first # Returns a single LocationCategory object
NoaaNceiWeather::LocationCategory.find("CITY") # Returns a single LocationCategory with the given ID
```

Many of these endpoints also have relationships with one another. For example, each location category has many locations. This is shown as an optional parameter on the NOAA page for the [location endpoint](http://www.ncdc.noaa.gov/cdo-web/webservices/v2#locations). To reflect this relationship, `LocationCategory` has an instance method `.locations` to retrieve the related records. The same is true for the other classes where available via parameters shown on the NOAA documentation

```ruby
lc = NoaaNceiWeather::LocationCategory.first # returns a single instance of LocationCategory
lc.locations # returns a collection of Location objects related to lc
```

Parameters passed to the class methods are parsed before being sent to the NOAA API for convenience.
  1. Relationship parameters to another endpoint can be passed an object instance. For example:

    ```ruby
    lc = NoaaNceiWeather::LocationCategory.find('CITY') # an instance of LocationCategory
    NoaaNceiWeather::Location.where(locationcategoryid: lc.id) # Parameter shown on the NOAA API Docs
    NoaaNceiWeather::Location.where(locationcategory: lc) # alternative
    ```

  2. Date parameters shown in the NOAA parameters can be given as Ruby `Date`, `DateTime`, or `Time` instances rather than an ISO formatted string

Limit is a parameter available to all the NOAA endpoints. Limit is being handled in the query so you can exceed the documented NOAA limit of a maximum 1000 per query. The `.all` method will return all of the available records, even if there are more than 1000. You may also set a limit of something over 1000 and that number will be returned to you. For example:

```ruby
data = NoaaNceiWeather::DataType.all
data.count # => 1461 - the current count as of this writing
data = NoaaNceiWeather::DataType.where(limit: 1200)
data.count # => 1200 - passing a 1200 limit to the noaa api directly would raise a bad request error
```


The /data endpoint and corresponding `Data` class is where most of the real data is stored. The NOAA API required parameters are required in the class method, while the rest are passed with a hash as with the other classes. This returns a collection of Data objects.

```ruby
ds = NoaaNceiWeather::Dataset.first
date = Date.today - 14
data = NoaaNceiWeather::Data.query(ds, date, date, {offset: 0})
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com//JasonBThelen/noaa_ncei_weather.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
