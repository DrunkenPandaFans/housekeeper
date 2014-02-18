require "test_helper"

describe Housekeeper::Circle do 

  before do
    @circles = Housekeeper::mongo["circles"]
    @users = Housekeeper::mongo["users"]
  end

  after do
    @circles.remove()
    @users.remove()
  end

  subject do
    token = Housekeeper::GoogleToken.new "abcsd", "accessthis", 1234, Time.at(765432109)
    user = Housekeeper::User.new "octo@github.com", token
    user.save

    item = Housekeeper::ShoppingItem.new "Octocat sticker", "12321asda", 2
    list = Housekeeper::ShoppingList.new Time.new(2014, 2, 1), "GitHub Store", [item]
    circle = Housekeeper::Circle.new "Octocat Truthful", "The True Octocat lovers", user.id
    circle.shopping_lists = [list]
    circle
  end

  describe "save" do
    
    it "saves circle to database" do
      saved = subject.save

      circle = @circles.find({"_id" => BSON::ObjectId.from_string(saved.id)}).first

      saved.name.must_equal circle["name"]
      saved.description.must_equal circle["description"]
      saved.moderator.must_equal circle["moderator"]
      saved.shopping_lists.zip(circle["shopping_lists"]).each do |(actual, expected)|
        actual.date.gmtime.must_equal expected["date"]
        actual.shop.must_equal expected["shop"]        
        actual.items.zip(expected["items"]).each do |(ai, ei)|
          ai.name.must_equal ei["name"]
          ai.requestor.must_equal ei["requestor"]
          ai.amount.must_equal ei["amount"]
        end
      end
    end

    it "saves circle without shopping lists" do
      subject.shopping_lists = nil
      saved = subject.save

      circle = @circles.find({"_id" => BSON::ObjectId.from_string(saved.id)}).first

      saved.name.must_equal circle["name"]
      saved.description.must_equal circle["description"]
      saved.moderator.must_equal circle["moderator"]
      circle["shopping_lists"].must_be_empty
    end

    it "sets circle id" do
      saved = subject.save
      saved.wont_be_nil saved.id
    end

    it "returns self" do
      saved = subject.save
      saved.must_be_same_as subject
    end    

  end

  describe "update" do

    before do
      subject.save
    end

    it "updates circle in database" do
      subject.name = "Octocat"
      subject.description = "Shopping awesome octocat stuff"

      subject.update

      circle = @circles.find({"_id" => BSON::ObjectId.from_string(subject.id)}).first      
      subject.name.must_equal circle["name"]
      subject.description.must_equal circle["description"]
      subject.moderator.must_equal circle["moderator"]
    end

    it "returns itself" do
      updated = subject.update
      updated.must_be_same_as subject
    end

    it "updates circle without shopping lists" do
      subject.shopping_lists = nil
      subject.update

      circle = @circles.find({"_id" => BSON::ObjectId.from_string(subject.id)}).first

      subject.name.must_equal circle["name"]
      subject.description.must_equal circle["description"]
      subject.moderator.must_equal circle["moderator"]
      circle["shopping_lists"].must_be_empty
    end
  end

  describe "find" do

    before do
      subject.save
    end

    it "returns existing circle with given id" do
      
      found = Housekeeper::Circle.find(subject.id)

      found.name.must_equal subject.name
      found.description.must_equal subject.description
      found.moderator.must_equal subject.moderator
      found.shopping_lists.zip(subject.shopping_lists).each do |(f, e)|
        f.date.gmtime.must_equal e.date.gmtime
        f.shop.must_equal e.shop
        f.items.zip(e.items).each do |(fi, ei)|
          fi.name.must_equal ei.name
          fi.amount.must_equal ei.amount
          fi.requestor.must_equal ei.requestor
        end
      end
    end

    it "should return existing circle even if it doesn't contains shopping lists" do
      subject.shopping_lists = nil
      subject.update

      found = Housekeeper::Circle.find(subject.id)

      found.name.must_equal subject.name
      found.description.must_equal subject.description
      found.moderator.must_equal subject.moderator
      found.shopping_lists.must_be_empty
    end

    it "returns nil if circle does not exist" do
      found = Housekeeper::Circle.find("507f1f77bcf86cd799439011")
      found.must_be_nil
    end

  end

  describe "remove" do

    before do
      subject.save
    end

    it "removes circle from collection" do
      Housekeeper::Circle.remove(subject.id)

      data = @circles.find({"_id" => subject.id})
      data.has_next?.must_equal false
    end

  end

  describe "find_by_moderator" do

    before do
      subject.save
    end

    it "finds circles of given moderator" do
      actual = Housekeeper::Circle.find_by_moderator(subject.moderator)
      
      actual.size.must_equal 1
      found = actual[0]
      found.id.must_equal subject.id
      found.name.must_equal subject.name
      found.description.must_equal subject.description
      found.moderator.must_equal subject.moderator      
    end

    it "returns empty array for moderator that does not exist" do
      actual = Housekeeper::Circle.find_by_moderator("octo mama")
      actual.must_be_empty
    end
  end
  
end
