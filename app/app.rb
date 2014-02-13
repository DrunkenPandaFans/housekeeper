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

    before do
      if api_request?
        user_id = parse_user_id(request["Authorization"])
        user_id = session[:user] unless user_id.blank?
        user = User.find(user_id)
        
        content_type :json

        return halt 401, "Only authenticated users have access to this resource!" if !user

        session[:user] = user
      else
        true
      end
    end

    get "/" do
      redirect "index.html"
    end

    # Public: Parses user id from Authorization header.
    #
    # header - The String authorization header
    #
    # Returns user id from header or empty string if header does not contain id.
    def parse_user_id(header)
      return "" unless header
      header.match(/Bearer (\w+)/).capture
    end

    # Public: Checks if request is for API resource.
    #
    # Return true if request is for API resource, false otherwise.
    def api_request?
      is_api_request = request.path_info =~ /\// ||
                       request.path_info =~ /\/fonts/ ||
                       request.path_info =~ /\/connect/
      !is_api_request
    end
  end
end
