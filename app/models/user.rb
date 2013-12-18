module Housekeeper
  class User
    # Public: Username of user's Google account
    attr_accessor :login

    # Public: The email address listed on Google account
    attr_accessor :email

    # Public: The personal authentication token to access Housekeeper API.
    attr_accessor :token

    # Public: The authentication token to Google Sign In
    attr_accessor :google_token

    # Public: The indicator if user wants to get sms notifications
    attr_accessor :send_sms

    # Public: The id of user's default group
    attr_accessor :default_group

    # Public: Initialize a user.
    #
    # login - The String login of user's Google account
    # email - The String email address of user's Google account.    
    # google_token - The GoogleToken authentication token to Google Sign In
    # token - The String personal token to access Housekeeper API.
    def initialize(login, email, google_token, token=nil)
      @login = login
      @email = email
      @token = token
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

    # Public: Finds user.
    #
    # login - The String login that should be used to find user
    #
    # Returns the User, or nil if user is not found.
    def self.find(login)
      login.downcase!
      data = Housekeeper::mongo["users"].find({"login" => login}).first

      return nil if data == nil
      
      User.transform(data)      
    end

    # Public: Finds user by token.
    #
    # token - The String personal user token to access Housekeeper API
    #
    # Returns the User, or nil if user is not found.
    def self.find_by_token(token)
      data = Housekeeper::mongo["users"].find({"_id" => token}).first
      
      return nil if data == nil
      
      User.transform(data)
    end

    # Public: Save the user
    #
    # Returns itself
    def save
      data = {"login" => @login,
              "email" => @email,
              "google_token" => @google_token.to_hash,
              "send_sms" => @send_sms,
              "default_group" => @default_group}
      Housekeeper::mongo["users"].insert(data)
      self
    end

    # Public: Update the user
    #
    # Returns itself
    def update
      data = {"_id" => @token,
              "login" => @login,
              "email" => @email,
              "google_token" => @google_token.to_hash,
              "send_sms" => @send_sms,
              "default_group" => @default_group}
      Housekeeper::mongo["users"].update({"_id" => @token}, data)
      self
    end

    private

    def self.transform(user_data)
      google_token = GoogleToken.create user_data["google_token"]
      user = User.new user_data["login"], user_data["email"], 
        google_token, user_data["_id"].to_s
      user.send_sms = user_data["send_sms"],
      user.default_group = user_data["default_group"]
      user
    end
  end

end
