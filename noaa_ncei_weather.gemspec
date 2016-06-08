# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'noaa_ncei_weather/version'

Gem::Specification.new do |spec|
  spec.name          = "noaa_ncei_weather"
  spec.version       = NoaaNceiWeather::VERSION
  spec.authors       = ["Jason B Thelen"]
  spec.email         = ["jason.thelen@gmail.com"]

  spec.summary       = "Ruby wrapper for the NOAA NCEI Historical Weather API."
  spec.description   = "Ruby wrapper for the NOAA NCEI Historical Weather API."
  spec.homepage      = "https://github.com/JasonBThelen/noaa_ncei_weather"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'pry'

  spec.add_runtime_dependency 'rest-client', '~> 1.8'
end
