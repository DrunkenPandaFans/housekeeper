module Housekeeper

  #Public: Various methods to access and retrieve user data from Google API.
  class GoogleService

    # Public: Retrieve user profile information.
    #
    # token - The GoogleToken authentication token to access user's Google info.
    #
    # Returns user's profile information.
    def self.user_info(token)
      auth = build_auth
      auth.update_token!(token.to_hash)

      client = build_client
      client.authorization = auth

      plus = client.discovered_api('plus', 'v1')

      # We should handle errors here
      client.execute!(plus.people.get, :userId => 'me').data
    end

    # Public: Retrieve user email.
    #
    # token - The GoogleToken authentication token to access user's email address
    #
    # Returns user's email address
    def self.user_email(token)
      auth = build_auth
      auth.update_token!(token.to_hash)

      client = build_client
      client.authorization = auth

      oauth = client.discovered_api('oauth2', 'v2')

      client.execute!(oauth.userinfo.get).data["email"]
    end

    # Public: Retrieve user's Google Token.
    #
    # auth_code - The string authentication code, that can be exchange for token.
    #
    # Returns google token to access user's information.
    def self.get_token(auth_code)
      auth = build_auth
      auth.code = auth_code
      auth.grant_type = 'authorization_code'

      begin
        data = auth.fetch_access_token
      rescue Signet::AuthorizationError => err
        data = nil
        # log error here
      end

      return nil if data == nil

      data["issued_at"] = Time.now.to_i
      GoogleToken.create(data)
    end

    private

    # Private: Build new client.
    #
    # Returns new Google API client.
    def self.build_client
      Google::APIClient.new
    end

    # Private: Build new authorization client based on configuration settings.
    #
    # Returns new authorization client.
    def self.build_auth
      Signet::OAuth2::Client.new(
          :authorization_uri => Housekeeper::config[:google_auth_uri],
          :token_credential_uri => Housekeeper::config[:google_token_uri],
          :client_id => Housekeeper::config[:client_id],
          :client_secret => Housekeeper::config[:client_secret],
          :scope => 'https://www.googleapis.com/auth/plus.login' + 
            'https://www.googleapis.com/auth/userinfo.email',
          :redirect_uri => 'postmessage'
      )
    end
  end
end
