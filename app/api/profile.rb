module Housekeeper
  class Profile < Sinatra::Base

    post '/connect' do
        #TODO try to find user app token and find if user is already registered
        #TODO check if user token didn't expired, if it did refresh it
        #TODO otherwise use it to load user's google profile
        #TODO if user was not found, get user's token and information
        #TODO and try to find him in database
        #TODO if user was not found create new user
    end

    post '/disconnect' do
      #TODO remove user from session
      #TODO reset session state
    end
  end
end
