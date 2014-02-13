module Housekeeper
  class Profile < Sinatra::Base

    post '/connect' do      
      content_type :json

      if !session[:user]
        # Fetch new user google token
        authData = JSON.parse(request.body.read)
        code = authData["code"]

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

        # Send user info to client
        profile.to_json      
      else
        # Find user by token        
        user = session[:user]

        if !user
          halt 401
        end

        # Refresh token if it is expired
        if user.google_token.expired?
          new_token = GoogleService.get_token(user.google_token.refresh_code)
          user.google_token = new_token
          user.update
        end

        # Send user info to client
        load_profile(user.google_token).to_json
      end
    end

    post '/disconnect' do      
      halt 401, "User was not logged in" unless session[:user]               
      session.delete(:user)      
      status 201      
    end

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
