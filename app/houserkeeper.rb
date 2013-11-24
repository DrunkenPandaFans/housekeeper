module Housekeeper

  def self.config
    {:secret => yaml['google_secret'],
     :client_id => yaml['google_key'],
     :mongo_host => yaml['mongo_host'],
     :mongo_port => yaml['mongo_port'],
     :mongo_db => yaml['mongo_db']}
  end

  def self.yaml
    if File.exists?('config/play.yml')
      @yaml ||= YAML.load_file('config/play.yml')
    else
      {}
    end
  end
end
