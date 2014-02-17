module Housekeeper
  class Circle

    attr_accessor :id

    attr_accessor :name

    attr_accessor :description    

    attr_accessor :shopping_lists

    attr_accessor :moderator

    attr_accessor :members  

    def initialize(name, description = "", moderator)
      @name = name
      @description = description
      @moderator = moderator      
    end

    def save    
      data = to_hash
      data.delete("id")

      @id = Housekeeper::mongo["circles"].insert(data).to_s
      self
    end

    def update
      object_id = BSON::ObjectId.from_string(@id)
      data = to_hash
      data.delete("id")
      data["_id"] = object_id

      Housekeeper::mongo["circles"].update({"_id" => object_id}, data)
      self
    end

    def is_member?(user)
      members =  @members.select do |member|
        user.id = member.id
      end

      @moderator == user.id || members.size > 0
    end      

    def to_hash()
      {"id" => @id,
       "name" => @name,
       "description" => @description, 
       "shopping_lists" => convert_shopping_lists(),
       "moderator" => @moderator,
       "members" => convert_members()}
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

    def self.find_by_member(member)
      data = Housekeeper::mongo["circles"].find({ "users" => { :$in => [member]}}, 
        {:fields => ["_id", "name", "moderator", "description"]})

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
      circle.members = data["members"].map do |user_id|
        Housekeeper::User.find(user_id)
      end
      circle
    end

    def convert_shopping_lists
      return [] if @shopping_lists.nil?
      @shopping_lists.map do |list|
        list.to_hash
      end
    end

    def convert_members
      return [] if @members.nil?
      @members.map do |member|
        member.id
      end
    end

  end
end
