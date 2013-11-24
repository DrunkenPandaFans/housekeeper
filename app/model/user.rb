module Housekeeper
  class User
    
    attr_accessor :token

    attr_accessor :email

    attr_accessor :default_group

    attr_accessor :google_token

    attr_accessor :send_sms

    def initialize(email, google_token)
      @email = email
      @google_token = google_token
      @send_sms = false
    end

    def initialize(user) 
      @email = user["email"]
      @google_token = user["google_token"]
      @send_sms = user["send_sms"]
      @default_group = user["default_group"]
      @token = user["_id"]
    end

    def save()
      user = {"email" => @email,
              "default_group" => @default_group,
              "send_sms" => @send_sms}
      $mongo.db["users"].insert(user)
    end

    def update()
      user = {"email" => @email,
              "default_group" => @default_group,
              "send_sms" => @send_sms}
      $mongo.db["users"].update({"_id" => @token}, user})
    end

    def self.remove(token)
      $mongo.db["users"].remove("i" => token)
    end

    def self.find(token)
      user = $mongo.db["users"].find("_id" => token)
      User.initialize(user)
    end

    def self.find_all()
      users = $mongo.db["users"].find.map { |user| 
        User.initialize(user)
      }
    end
  end
end
