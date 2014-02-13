module Housekeeper
  class GoogleToken

    # Public: Token to get new access token after this one expires.
    attr_accessor :refresh_token
    
    # Public: Token to access Google API on behalf of user.
    attr_accessor :access_token
    
    # Public: Number of seconds from issued_at when this token expires
    attr_accessor :expires_in
    
    # Public: Date and Time when token was issued
    attr_accessor :issued_at

    # Public: Initialize a Google token.
    #
    # refresh_token - The String token used to refresh google token.
    # access_token - The String token used to access Google API.
    # expires_in - The Long, number of seconds till token expires.
    # issued_at - The Time, time when token was issued.
    def initialize(refresh_token, access_token, expires_in, issued_at)
      @refresh_token = refresh_token
      @access_token = access_token
      @expires_in = expires_in
      @issued_at = issued_at
    end

    # Public: Creates a Google token from hash.
    #
    # data - The Hash, data from Mongo representing Google token.
    #
    # Returns a Google token created from data.
    def self.create(data)
      GoogleToken.new(data["refresh_token"], data["access_token"],
                      data["expires_in"], data["issued_at"])
    end    

    # Public: Checks if token is expired.
    #
    # Returns true if token is expired, false otherwise.
    def expired?
      now = Time.now
      expiration_time = @issued_at + @expires_in
      now >= expiration_time
    end

    # Public: Converts Google token to hash
    #
    # Returns hash, that is converted from token.
    def to_hash
      {"refresh_token" => @refresh_token,
       "access_token" => @access_token,
       "expires_in" => @expires_in,
       "issued_at" => @issued_at}
    end

  end
end
