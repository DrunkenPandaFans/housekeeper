require 'test_helper'
require 'models/user'

describe Housekeeper::User do
  
  before do
    db = mock()
    @collection = mock()
    db.expects(:[]).with("users").returns(@collection)

    Housekeeper.expects(:mongo).returns(db)
  end

  describe "should save user" do
    subject do
      token = Housekeeper::GoogleToken.new "abcsd", "accessthis", 1234, 765432109
      Housekeeper::User.new "octocat", "octo@github.com", token
    end
    
    it "user call insert on 'users' collection" do
      expectedDoc = {"_id" => "octocat",
                     "email" => "octo@github.com",
                     "google_token" => {
                        "refresh_token" => "abcsd",
                        "access_token" => "accessthis",
                        "expires_in" => 1234,
                        "issued_at" => 765432109
                      }}
      @collection.expects(:insert).with(expectedDoc).once    

      subject.save          
    end

    it "returns itself" do
      @collection.expects(:insert).once
      actual = subject.save
      actual.must_equal subject
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
