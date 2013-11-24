$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require 'mongo'
require 'yaml'

MONGO_URL = 'localhost:27017'
$MONGO = MongoClient.new(MONGO_URL)
