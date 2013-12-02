$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require 'mongo'
require 'yaml'
require 'json'
require 'google/api_client'
require 'sinatra/base'

require 'housekeeper'

require 'services/google'

require 'models/user'

include Mongo

require 'app'
