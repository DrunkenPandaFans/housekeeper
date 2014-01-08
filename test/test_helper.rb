ENV['RACK_ENV'] = 'test'

require 'simplecov'
require 'coveralls'

# load test libraries
require 'minitest/autorun'
require 'minitest/spec'
require 'rack/test'
require 'mocha/setup'

# Start test coverage
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start

require 'boot'
