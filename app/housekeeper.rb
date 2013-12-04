module Housekeeper

  # Public: Return instance of Mongo client for actual configuration
  #
  # Returns instance of MongoDB client.
  def self.mongo
    return @client.db if @client != nil
    @client = MongoClient.new config[":mongo_host"], config[":mongo_port"]      
    @client.db
  end  

  # Public: Return application configuration
  #
  # Returns application configuration.
  def self.config
    {:client_secret => yaml['google_secret'],
     :client_id => yaml['google_key'],
     :mongo_host => yaml['mongo_host'],
     :mongo_port => yaml['mongo_port'],
     :mongo_db => yaml['mongo_db'],
     :google_auth_uri => yaml['google_auth_uri'],
     :google_token_uri => yaml['google_token_uri']}
  end

  private 

    # Public: Return parsed yaml configuration file
    #
    # Returns parsed yaml configuration file or empty hash if file is not found.
    def self.yaml
      if File.exists?('config/housekeeper.yml')
        @yaml ||= YAML.load_file('config/housekeeper.yml')
      else
        {}
      end
    end
end
