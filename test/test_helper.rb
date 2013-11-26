require 'simplecov'
require 'coveralls'

# load test libraries
require 'minitest/autorun'
require 'minitest/spec'
require 'mocha/setup'

# Start test coverage
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start

require 'boot.rb'
