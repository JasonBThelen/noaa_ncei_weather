Gem::Specification.new do |s|
  s.name        = 'NOAA NCEI Weather'
  s.version     = '0.1.0'
  s.licenses    = ['MIT']
  s.summary     = "Ruby wrapper for the NOAA NCEI Historical Weather API"
  s.description = "This is a wrapper for the"
  s.authors     = ["Jason B Thelen"]
  s.email       = 'jason.thelen@gmail.com'
  s.files       = ["lib/noaa_ncei_weather.rb"]
  s.homepage    = 'https://github.com' #Set to github page when setup
  s.add_runtime_dependency 'rest-client'
end
