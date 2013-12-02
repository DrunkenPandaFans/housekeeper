require 'api/profile'

module Housekeeper 
  class App < Sinatra::Base
    
    # Enable sessions and set session secret.
    # So that in development mode sessions are not invalidated
    enable :sessions
    set    :session_secret, Housekeeper.config[:auth_token]

    # Set folder with public assets
    dir = File.dirname(File.expand_path(__FILE__))
    set :public_folder, "#{dir}/frontend"
    set :static, true

    get "/" do
      content_type :html
      send_file('index.html')
    end
  end
end
