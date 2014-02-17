module Housekeeper
  class Circle

    attr_accessor :id

    attr_accessor :name

    attr_accessor :description    

    attr_accessor :shopping_lists

    attr_accessor :moderator     

    def initialize(name, description, moderator)
      @name = name
      @description = description
      @moderator = moderator
      @users = []
    end

    def save    
      data = {"name" => @name,
              "description" => @description,
              "shopping_lists" => convert_shopping_lists(),
              "moderator" => moderator}

      @id = Housekeeper::mongo["circles"].insert(data).to_s
      self
    end

    def update
      object_id = BSON::ObjectId.from_string(@id)
      data = {
        "_id" => object_id,
        "name" => @name,
        "description" => @description,
        "shopping_lists" => convert_shopping_lists(),
        "moderator" => @moderator        
      }

      Housekeeper::mongo["circles"].update({"_id" => object_id}, data)
      self
    end

    def self.add_user(circle_id, user_id)      
      circle_key = BSON::ObjectId.from_string(circle_id)

      Housekeeper::mongo["circles"].update({"_id" => circle_key},
        {:$push => { "users" => user_id}})
    end

    def self.remove_user(circle_id, user_id)
      circle_key = BSON::ObjectId.from_string(circle_id)

      Housekeeper::mongo["circles"].update({"_id" => circle_key},
        {:$pull => { "users" => user_id}})
    end

    def self.find_users(circle_id)      
      user_ids = Housekeeper::mongo["circles"].find({"_id" => circle_id}, 
        {:fields => ["users"]})

      users_data = Housekeeper::mongo["users"].find({"_id" => { :$in => circle.users}})
      users_data.map do |data|
        User.transform(data)
      end
    end

    def self.remove(id)
      object_id = BSON::ObjectId.from_string(id)

      Housekeeper::mongo["circles"].remove({"_id" => object_id})
    end

    def self.find(id)
      object_id = BSON::ObjectId.from_string(id)      

      data = Housekeeper::mongo["circles"].find({"_id" => object_id}).first
      return nil unless data
     
      transform(data)      
    end

    def self.find_by_moderator(moderator)
      data = Housekeeper::mongo["circles"].find({"moderator" => moderator}, 
        {:fields => ["_id", "name", "description", "moderator"]})
      
      data.map do |d|
        circle = Circle.new d["name"], d["description"], d["moderator"]
        circle.id = d["_id"].to_s
        circle
      end
    end

    private

    def self.transform(data)
      circle = Circle.new data["name"], data["description"], data["moderator"]
      circle.id = data["_id"].to_s
      circle.shopping_lists = data["shopping_lists"].map do |list|
        Housekeeper::ShoppingList.from_hash(list)
      end
      circle
    end

    def convert_shopping_lists
      return [] if @shopping_lists.nil?
      @shopping_lists.map do |list|
        list.to_hash
      end
    end
  end
end
