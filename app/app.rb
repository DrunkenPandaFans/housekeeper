require 'api/profile'

module Housekeeper
  class App < Sinatra::Base

    # Load parts of API
    use Profile

    # Enable sessions and set session secret.
    # So that in development mode sessions are not invalidated
    enable :sessions
    set :session_secret, 'asdf4fdsafas'

    # Set folder with public assets
    dir = File.dirname(File.expand_path(__FILE__))
    set :public_folder, "#{dir}/frontend"
    set :static, true
    
    def api_request?
      is_api_request = request.path_info =~ /\// ||
                       request.path_info =~ /\/fonts/ ||
                       request.path_info =~ /\/connect/
      !is_api_request
    end

    before do
      if api_request?
        user_id = session[:user] || ""        
        user = User.find(user_id)
        
        content_type :json

        return halt 401, "Only authenticated users have access to this resource!" if !user

        session[:user] = user_id
      else
        true
      end
    end

    get "/" do
      redirect "index.html"
    end
  end
end
