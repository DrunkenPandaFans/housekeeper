module Housekeeper
  class Circles < Sinatra::Base

    get "/circle" do
      user = session[:user]
      halt 401 if !user
      user_id = user.id

      moderated = Housekeeper::Circle.find_by_moderator(user_id)
      circles = transform_circles(moderated, true)

      member = Housekeeper::Circle.find_by_member(user_id)
      member.select! do |circle|
        circle.moderator != user_id
      end
      circles.concat(transform_circles(member, false))

      status 201
      {"circles" => circles}.to_json
    end

    get "/circle/:id" do
      id = params[:id]

      begin
        circle =  Housekeeper::Circle.find(id)      
      rescue BSON::InvalidObjectId
        return halt 404, "Circle with id #{id} does not exist."
      end

      return halt 404, "Circle with id #{id} does not exist" unless circle

      user = session[:user]
      
      if circle.is_member? user
        status 201
        circle.to_hash.to_json
      else
        return halt 403, "User with sent access token does not have access to this circle"
      end

    end

    post "/circle" do
      data = JSON.parse(request.body.read)

      errors = []
      if !data["name"] || data["name"].strip.empty?
        errors << "Circle is missing name"
      end

      if !errors.empty?
        return halt 400, errors.to_json
      end

      moderator = session[:user].id
      data["moderator"] = moderator

      description = data["description"]
      description = "" unless description

      circle = Housekeeper::Circle.new data["name"], description, moderator

      if data["members"]
        members = data["members"].map do |user_id|
          Housekeeper::User.find(user_id)
        end
        circle.members = members
      end      

      circle.save
      
      status 201
    end

    put "/circle/:id" do
      # update circle
      id = params[:id]
      user = session[:user]

      original = Housekeeper::Circle.find(id)
      if !original
        return 404, "Circle does not exists."
      end

      if original.moderator != user.id
        return halt 403, "User does not have permission to update circle."
      end

      data = JSON.parse(request.body.read)

      updated = Housekeeper::Circle.transform(data)
      updated.id = id
      updated.moderator = user.id
      
      updated.update

      status 201
    end

    delete "/circle/:id" do
      circle_id = params[:id]

      begin
        circle = Housekeeper::Circle.find(circle_id)
      rescue BSON::InvalidObjectId
        return halt 404, "Circle with id #{circle_id} does not exists."
      end

      if !circle 
        return halt 404, "Circle with id #{circle_id} does not exists."
      end

      user_id = session[:user].id
      if circle.moderator != user_id
        return halt 403, "User is not moderator of this circle."
      end

      Housekeeper::Circle.remove(circle_id)
      status 201
    end 

    def transform_circles(circles, is_moderator)
      circles.map do |circle|
        result = circle.to_hash
        result["is_moderator"] = is_moderator
        result
      end      
    end  

  end
end
