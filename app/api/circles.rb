module Housekeeper
  class Circles < Sinatra::Base

    delete "/circle/:id" do
      circle_id = params[:id]

      begin
        circle = Housekeeper::Circle.find(circle_id)
      rescue BSON::InvalidObjectId
        return halt 401, "Circle with id #{circle_id} does not exists."
      end

      if !circle 
        return halt 401, "Circle with id #{circle_id} does not exists."
      end

      user_id = session[:user].id
      if circle.moderator != user_id
        return halt 403, "User is not moderator of this circle."
      end

      Housekeeper::Circle.remove(circle_id)
      status 201
    end

  end
end
