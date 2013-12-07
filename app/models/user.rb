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
    end

    # Public: Returns all users
    #
    # Returns all users.
    def self.all
      Housekeeper::mongo["users"].find.map do |data|
        User.transform(data)
      end
    end

    # Public: Finds user
    #
    # Returns the User, or nill if user is not found.
    def self.find(login)
      login.downcase!
      data = Housekeeper::mongo["users"].find({"login" => login})
      if data != nil
        User.transform(data)
      else
        nil
      end
    end

    # Public: Save the user
    #
    # Returns itself
    def save
      data = {"login" => @login,
              "email" => @email,
              "google_token" => @google_token.to_hash}
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
              "google_token" => @google_token.to_hash}
      Housekeeper::mongo["users"].update({"_id" => @token}, data)
      self
    end

    private

    def self.transform(user_data)
      google_token = GoogleToken.create user_data["google_token"]
      User.new user_data["login"], user_data["email"], google_token, user_data["_id"]
    end
  end

  class GoogleToken
    attr_accessor :refresh_token, :access_token, :expires_in, :issued_at

    def initialize(refresh_token, access_token, expires_in, issued_at)
      @refresh_token = refresh_token
      @access_token = access_token
      @expires_in = expires_in
      @issued_at = Time.at(issued_at)
    end

    def self.create(data)
      GoogleToken.new(data["refresh_token"], data["access_token"],
                      data["expires_in"], data["issued_at"])
    end

    def expired?
      now = Time.now
      expiration_time = @issued_at + @expires_in
      now >= expiration_time
    end

    def to_hash
      {"refresh_token" => @refresh_token,
       "access_token" => @access_token,
       "expires_in" => @expires_in,
       "issued_at" => @issued_at.to_i}
    end

  end
end
