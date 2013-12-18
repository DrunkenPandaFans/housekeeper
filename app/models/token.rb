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
