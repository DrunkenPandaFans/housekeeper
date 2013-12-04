module Housekeeper
  class Profile < Sinatra::Base

    post '/connect' do
        #TODO try to find user app token and find if user is already registered
        if !session[:user]
          authData = JSON.parse(request.body.read)
          code = authData["code"]

          token = Housekeeper::GoogleService.get_token(code)
          #TODO otherwise use it to load user's google profile
          userProfile = Housekeeper::GoogleService::user_info(token)
          
          #TODO fetch user's email
          login = userProfile["nickname"]
          
          #TODO if user was not found create new user
          user = User.new login, email, token
          user.save

          session[:user] = user

          content_type :json
          userProfile.to_json
        else
          #TODO check if user token didn't expired, if it did refresh it
          content_type :json
          "Current user is already connected.".to_json
        end                                              
    end

    post '/disconnect' do
      #TODO remove user from session
      #TODO reset session state
    end
  end
end
