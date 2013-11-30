$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require 'mongo'
require 'yaml'

require "housekeeper"
require 'models/user'

include Mongo