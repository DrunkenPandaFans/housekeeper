module Housekeeper
  class Circles < Sinatra::Base

    get "/circle" do
      user = session[:user]
      user_id = user.id

      moderated = Housekeeper::Circle.find_by_moderator(user_id)
      circles = moderated.map do |circle|
        result = circle.to_hash
        result["is_moderator"] = true
      end

      member = Housekeeper::Circle.find_by_member(user_id)
      circles << member.map do |circle|
        result = circle.to_hash
        result["is_moderator"] = false
      end

      status 201
      circles.to_json
    end

    get "/circle/:id" do
      id = params[:id]

      circle =  Housekeeper::Circle.find(id)      
      user = session[:user]      
      
      if circle.is_member? user
        status 201
        circle.to_json
      else
        halt status 403, "User with sent access token does not have access to this circle"
      end

    end

    post "/circle" do
      data = JSON.parse(request.body)

      errors = []
      if !data.name || data.name.blank?
        errors << "Circle is missing name"
      end


      if errors
        return halt 400, errors.to_json
      end

      moderator = session[:user].id
      data["moderator"] = moderator

      description = data["description"]
      description = "" unless description

      circle = Housekeeper::Circle data["name"], description, moderator      

      circle.save
    end

    put "/circle/:id" do
      # update circle
    end

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
