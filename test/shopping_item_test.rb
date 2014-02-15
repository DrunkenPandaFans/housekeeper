require 'test_helper'

describe Housekeeper::ShoppingItem do

  describe "to_hash" do

    it "creates hash with all attributes" do
      item = Housekeeper::ShoppingItem.new "octocar sticker", "abc123432", 2
      
      data = item.to_hash
      data["name"].must_equal item.name
      data["requestor"].must_equal item.requestor
      data["amount"].must_equal item.amount
    end

  end

  describe "from_hash" do

    subject do
      data = {"name" => "octocat sticker",
              "requestor" => "abc123432",
              "amount" => 2}
    end
    
    it "creates new instance with key values" do      
      item = Housekeeper::ShoppingItem.from_hash(subject)
      item.name.must_equal subject["name"]
      item.requestor.must_equal subject["requestor"]
      item.amount.must_equal subject["amount"]
    end

    it "uses default value if name is missing" do
      subject.delete("name")

      item = Housekeeper::ShoppingItem.from_hash(subject)
      item.name.must_equal "Unknown"
      item.requestor.must_equal subject["requestor"]
      item.amount.must_equal subject["amount"]      
    end

    it "uses default value if requestor is missing" do
      subject.delete("requestor")

      item = Housekeeper::ShoppingItem.from_hash(subject)
      item.name.must_equal subject["name"]
      item.requestor.must_equal ""
      item.amount.must_equal 2
    end

    it "uses default value if amount is missing" do
      subject.delete("amount")

      item = Housekeeper::ShoppingItem.from_hash(subject)
      item.name.must_equal subject["name"]
      item.requestor.must_equal subject["requestor"]
      item.amount.must_equal 1
    end
  end

end