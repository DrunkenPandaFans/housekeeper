module Housekeeper
  class User
    
    def initialize(database)
      @db = database
    end

    def save(user)
      data = {"default_group" => user[:default_group],
              "email" => user[:email],
              "send_sms" => user[:send_sms],
              "google_token" => user[:google_token]}

      @db["users"].insert(data)
    end

    def update(user)
      data = {"_id" => user[:token],
              "default_group" => user[:default_group],
              "email" => user[:email],
              "send_sms" => user[:send_sms],
              "google_token" => user[:google_token]}
      
      @db["users"].update({"_id" => user[:token]}, data)
    end

    def remove(token)
      @db["users"].remove("_id" => token)
    end

    def find(token)
      data = @db["users"].find("_id" => token)
      transform(data)
    end

    def find_all()
      users = @db["users"].find.map(transform)
    end

  private

    def transform(data)
      {:token => data['_id'],
       :default_group => data['default_group'],
       :send_sms => data['send_sms'],
       :email => data['email'],
       :google_token => data['google_token']}
    end
  end
end
