require 'test_helper'

describe Housekeeper::ShoppingList do

  subject do
    itemA = Housekeeper::ShoppingItem.new "octocat sticker", "avvcxcvc1", 2
    itemB = Housekeeper::ShoppingItem.new "I octocat my code shirt", "adsadsadsa", 1
    Housekeeper::ShoppingList.new Time.new(2014, 2, 1), "Github Store", [itemA, itemB]
  end

  describe "to_hash" do

    it "returns hash with all shopping list attributes" do
      data = subject.to_hash

      data["date"].must_equal subject.date
      data["shop"].must_equal subject.shop
      data["items"].zip(subject.items).each do |(actual, expected)|
        actual["name"].must_equal expected.name
        actual["requestor"].must_equal expected.requestor
        actual["amount"].must_equal expected.amount
      end
    end

  end

  describe "served?" do

    it "returns false if shopping list date is after now" do
      subject.date = Time.now + 3600
      subject.served?.must_equal false
    end

    it "returns true if shopping list date is before now" do
      subject.served?.must_equal true
    end    

  end

  describe "from_hash" do

    it "converts shopping list to hash" do
      data = {"date" => Time.new(2014, 2, 1),
              "shop" => "Github Store",
              "items" => [
                {"name" => "octocat sticker",
                 "requestor" => "avvcxcvc1",
                 "amount" => 2},
                 {"name" => "I octocat my code shirt",
                  "requestor" => "adsadsadsa",
                  "amount" => 1}]}
      list = Housekeeper::ShoppingList.from_hash(data)

      list.date.must_equal data["date"]
      list.shop.must_equal data["shop"]
      list.items.zip(data["items"]).each do |(actual, expected)|
        actual.name.must_equal expected["name"]
        actual.requestor.must_equal expected["requestor"]
        actual.amount.must_equal expected["amount"]
      end
    end
  end

end