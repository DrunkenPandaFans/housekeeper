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
        userProfile = user_info(token)
        
        login = userProfile[:id]
        
        # Try find user
        user = User.find(login)
        if user
          # Update his token
          user.google_token = token
          user.update
        else
          # Create new user
          email = userProfile[:email]

          user = User.new(login, email, token)
          user.save
        end        

        # Set user to session
        session[:user] = user.token  

        # Send user info to client
        userProfile.to_json      
      else
        # Find user by token
        user_token = session[:user]
        user = User.find_by_token(user_token)

        if !user
          halt 401
        end

        # Refresh token if it is expired
        if user.google_token.expired?
          new_token = GoogleService.get_token(user.token.refresh_code)
          user.google_token = new_token
          user.update
        end

        # Send user info to client
        user_info(user.token).to_json
      end
    end

    def user_info(token)
      userProfile = GoogleService.user_info(token)
      userMail = GoogleService.user_email(token)

      {:id => userProfile["id"], 
       :displayName => userProfile["displayName"],
       :image => userProfile["image"]["url"],
       :url => userProfile["url"],
       :email => userMail}
    end

    post '/disconnect' do      
      session.delete(:user)      
    end
  end
end
