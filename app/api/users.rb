module Housekeeper
  class Users < Sinatra::Base

    get '/user/:email' do
      email = params[:email]

      user = Housekeeper::User.find_by_email(email)
      
      return halt 401, "User with this email does not exists" unless user
      
      prepare_user(user).to_json
    end

    get "/user/:id" do
      id = params[:id]

      user = Housekeeper::User.find(id);
      prepare_user(user).to_json
    end

    get '/user' do

      result = Housekeeper::User.all().map do |user|
        prepare_user(user) 
      end

      result.to_json
    end

    def prepare_user(user)
      user_hash = user.to_hash
      {"id" => user.id,
       "email" => user.email}
    end
  end
end