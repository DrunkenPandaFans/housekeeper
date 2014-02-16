module Housekeeper
  class User    

    # Public: The email address listed on Google account
    attr_accessor :email

    # Public: The personal authentication token to access Housekeeper API.
    attr_accessor :id

    # Public: The authentication token to Google Sign In
    attr_accessor :google_token

    # Public: The indicator if user wants to get sms notifications
    attr_accessor :send_sms

    # Public: The id of user's default group
    attr_accessor :default_group

    # Public: Initialize a user.
    #    
    # email - The String email address of user's Google account.    
    # google_token - The GoogleToken authentication token to Google Sign In
    # token - The String personal token to access Housekeeper API.
    def initialize(email, google_token, token=nil)      
      @email = email
      @id = token
      @google_token = google_token
      @send_sms = false
      @default_group = ''
    end

    # Public: Returns all users
    #
    # Returns all users.
    def self.all
      Housekeeper::mongo["users"].find.map do |data|
        User.transform(data)
      end
    end    

    # Public: Finds user by id.
    #
    # id - The String personal user id to access Housekeeper API
    #
    # Returns the User, or nil if user is not found.
    def self.find(id)
      object_id = BSON::ObjectId.from_string(id.downcase)
      data = Housekeeper::mongo["users"].find({"_id" => object_id}).first
      
      return nil if data == nil
      
      User.transform(data)
    end

    # Public: Finds user by email.
    #
    # email - The String user email
    #
    # Returns the User or nil if user is not found.
    def self.find_by_email(email)
      data = Housekeeper::mongo["users"].find({"email" => email.downcase}).first

      return nil if data == nil

      User.transform(data)
    end

    # Public: Save the user
    #
    # Returns itself
    def save
      data = {"email" => @email,
              "google_token" => @google_token.to_hash,
              "send_sms" => @send_sms,
              "default_group" => @default_group}
      @id = Housekeeper::mongo["users"].insert(data).to_s
      self
    end

    # Public: Update the user
    #
    # Returns itself
    def update
      object_id = BSON::ObjectId.from_string(@id.downcase)
      data = {"_id" => object_id,
              "email" => @email,
              "google_token" => @google_token.to_hash,
              "send_sms" => @send_sms,
              "default_group" => @default_group}
      Housekeeper::mongo["users"].update({"_id" => object_id}, data)
      self
    end    

    # Public: Transform user's data to User.
    #
    # user_data - The hash representing user from Mongo.
    #
    # Returns user created from user_data.
    def self.transform(user_data)
      google_token = GoogleToken.create user_data["google_token"]
      user = User.new user_data["email"], 
        google_token, user_data["_id"].to_s
      user.send_sms = user_data["send_sms"],
      user.default_group = user_data["default_group"]
      user
    end
  end

end
