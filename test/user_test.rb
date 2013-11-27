require 'test_helper'
require 'models/user'

describe Housekeeper::User do
  
  before do
    @db = mock()
    @collection = mock()
    @db.expects(:[]).with("users").returns(@collection)
  end

  describe "should save user" do
    subject do
      Housekeeper::User.new @db
    end
    
    it "user call insert on 'users' collection" do
      expectedDoc = {"send_sms" => true,
                     "google_token" => "abcd",
                     "email" => "my@email.com",
                     "default_group" => "mygroup"}
      @collection.expects(:insert).with(expectedDoc).once
    

      subject.save({:send_sms => true,
                    :google_token => "abcd",
                    :email => "my@email.com",
                    :default_group => "mygroup"})          
    end
  end

  describe "should update user" do
    subject do
      Housekeeper::User.new @db
    end

    it "user calls update on 'users' collection" do
      expectedDoc = {"_id" => "token",
                     "send_sms" => true,
                     "google_token" => "abcds",
                     "email" => "my@email.com",
                     "default_group" => "mygroup"}
      @collection.expects(:update)
        .with({"_id" => "token"}, expectedDoc).once

      subject.update({:token => "token",
                      :send_sms => true,
                      :google_token => "abcds",
                      :email => "my@email.com",
                      :default_group => "mygroup"})
    end
  end

  describe "should get user based on user token" do
    subject do
      Housekeeper::User.new @db
    end

    it "user calls find with token to retrieve user" do
      expectedDoc = {:token => "token",
                     :send_sms => true,
                     :google_token => "abcdsd",
                     :email => "my@email.com",
                     :default_group => "mygroup"}
      @collection.expects(:find).with({"_id" => "token"})
        .returns({"_id" => "token",
                  "send_sms" => true,
                  "google_token" => "abcdsd",
                  "email" => "my@email.com",
                  "default_group" => "mygroup"})

      subject.find("token").must_equal expectedDoc
    end
  end
end
