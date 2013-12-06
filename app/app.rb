require 'api/profile'

module Housekeeper 
  class App < Sinatra::Base

    configure do      
      # load different parts of API
      use Profile
      # Enable sessions and set session secret.
      # So that in development mode sessions are not invalidated
      enable :sessions
      set    :session_secret, 'asdf4fdsafas'

      # Set folder with public assets
      dir = File.dirname(File.expand_path(__FILE__))
      set :public_folder, "#{dir}/frontend"
      set :static, true
    end
   
    get "/" do      
      redirect "index.html"  
    end
  end
end
