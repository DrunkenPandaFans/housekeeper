module Housekeeper
  class Profile < Sinatra::Base

    post '/connect' do      
      content_type :json

      if !session[:user]
        # Fetch new user google token
        auth_data = JSON.parse(request.body.read)
        puts auth_data
        code = auth_data["code"]

        token = GoogleService.get_token(code)

        # Fetch user profile information
        profile = load_profile(token)
        
        email = profile[:email]
        
        # Find user
        user = User.find_by_email(email)
        if user
          # Update his token
          user.google_token = token
          user.update
        else
          # Create new user          
          user = User.new(email, token)
          user.save
        end        

        # Set user to session
        session[:user] = user                        
      else
        # Find user by token        
        user = session[:user]

        # Refresh token if it is expired
        if user.google_token.expired?
          refresh_token = user.google_token.refresh_token
          refresh_token = user.google_token.access_token unless refresh_token

          new_token = GoogleService.get_token(refresh_token)
          user.google_token = new_token
          user.update
        end

        # Load user info to client
        profile = load_profile(user.google_token)        
      end
      
      # Send user info to client
      profile[:token] = session[:user].id

      status 201
      profile.to_json
    end

    post '/disconnect' do      
      halt 401, "User was not logged in" unless session[:user]               

      token = session[:user].google_token.refresh_token
      token = session[:user].google_token.access_token unless token

      session.delete(:user)

      revokePath = "https://accounts.google.com/o/oauth2/revoke?token=" + token
      uri = URI.parse(revokePath)
      request = Net::HTTP.new(uri.host, uri.port)
      request.use_ssl = true
      status request.get(uri.request_uri).code      
    end

    # Public: Loads user's profile data for given token.
    #
    # token - The GoogleToken to access google user's profile.
    #
    # Returns user's profile.
    def load_profile(token)
      profile = GoogleService.user_info(token)
      email_field = profile["emails"].select do |email| 
        email["type"] == "account"
      end

      email = email_field[0]["value"] if email_field && email_field.size > 0

      {:displayName => profile["displayName"],
       :image => profile["image"]["url"],
       :url => profile["url"],
       :email => email}     
    end
    
  end
end
