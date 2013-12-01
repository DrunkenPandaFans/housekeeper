require 'test_helper'
require 'models/user'

describe Housekeeper::User do
  
  before do
    db = mock()
    @collection = mock()
    db.expects(:[]).with("users").returns(@collection)

    Housekeeper.expects(:mongo).returns(db)    
  end  

  describe "save" do    

    subject do
      token = Housekeeper::GoogleToken.new "abcsd", "accessthis", 1234, 765432109
      Housekeeper::User.new "octocat", "octo@github.com", token      
    end    
    
    it "calls insert on 'users' collection" do
      expected_data = {"login" => "octocat",
                       "email" => "octo@github.com",
                       "google_token" => {
                        "refresh_token" => "abcsd",
                        "access_token" => "accessthis",
                        "expires_in" => 1234,
                        "issued_at" => 765432109}}
      @collection.expects(:insert).with(expected_data).once    

      subject.save          
    end

    it "returns itself" do
      @collection.expects(:insert).once
      subject.save.must_equal subject
    end
  end

  describe "update" do
    subject do
      token = Housekeeper::GoogleToken.new "abcsd", "accessthis", 1234, 765432109
      Housekeeper::User.new "octocat", "octo@github.com", token, "abcdefgh"
    end

    it "calls update on 'users' collection" do
      expected_data = {"_id" => "abcdefgh",
                       "login" => "octocat",
                       "email" => "octocat_mama@github.com",
                       "google_token" => {
                          "refresh_token" => "abcs3d", 
                          "access_token" => "accessthis2",
                          "expires_in" => 12345,
                          "issued_at" => 76543209}}

      @collection.expects(:update)
        .with({"_id" => "abcdefgh"}, expected_data).once

      subject.email = "octocat_mama@github.com"
      subject.google_token.refresh_token = "abcs3d"
      subject.google_token.access_token = "accessthis2"
      subject.google_token.expires_in = 12345
      subject.google_token.issued_at = 76543209

      subject.update
    end

    it "returns itself" do      
      @collection.expects(:update).once

      subject.email = "octocat_mama@github.com"

      subject.update.must_equal subject
    end
  end

  describe "find" do        

    before do
      @token = Housekeeper::GoogleToken.new "abcsd", "accessthis", 1234, 765432109
      @user = Housekeeper::User.new "octocat", "octo@github.com", @token, "abcdefghij" 
    end

    it "finds existing user by login" do      
      expected_data = {"_id" => @user.token,
                       "login" => @user.login,
                       "email" => @user.email,
                       "google_token" => @user.google_token.to_hash}

      @collection.expects(:find).with({"login" => @user.login})
        .returns(expected_data).once

      actual = Housekeeper::User.find(@user.login)

      actual.login.must_equal @user.login
      actual.email.must_equal @user.email
      actual.google_token.refresh_token.must_equal @user.google_token.refresh_token
      actual.google_token.access_token.must_equal @user.google_token.access_token
      actual.google_token.expires_in.must_equal @user.google_token.expires_in
      actual.google_token.issued_at.must_equal @user.google_token.issued_at
    end

    it "returns nil if user was not found" do
      @collection.expects(:find).returns(nil)

      Housekeeper::User.find("a chilling workaholic").must_be_nil
    end

    it "returns user if his login is in uppercase" do
      expected_data = {"_id" => @user.token,
                       "login" => @user.login,
                       "email" => @user.email,
                       "google_token" => @user.google_token.to_hash}

      @collection.expects(:find)
        .with({"login" => @user.login}).returns(expected_data)

      actual = Housekeeper::User.find(@user.login.upcase)

      actual.login.must_equal @user.login
      actual.email.must_equal @user.email
      actual.google_token.refresh_token.must_equal @token.refresh_token
      actual.google_token.access_token.must_equal @token.access_token
      actual.google_token.expires_in.must_equal @token.expires_in
      actual.google_token.issued_at.must_equal @token.issued_at
    end
  end

  describe "all" do
    before do
      token1 = Housekeeper::GoogleToken.new "abcsd", "accessthis", 1234, 765432109
      token2 = Housekeeper::GoogleToken.new "devil", "devilentered", 2345, 9876543
      user1 = Housekeeper::User.new "octocat", "octo@github.com", token1
      user2 = Housekeeper::User.new "unicorn", "unicorn@evilplace.com", token2
      @users = [user1, user2]
    end

    it "returns empty array if no user is in collection" do
      @collection.expects(:find).returns([])

      Housekeeper::User.all.must_be_empty
    end

    it "returns all users in collection" do
      users_data = @users.map do |user|
        {"_id" => user.token,
         "login" => user.login,
         "email" => user.email,
         "google_token" => user.google_token.to_hash}
      end

      @collection.expects(:find).returns(users_data).once

      actual_users = Housekeeper::User.all
      actual_users.size.must_equal 2
      
      actual_users.zip(@users).each do |a, e|
        a.login.must_equal e.login
        a.email.must_equal e.email
        a.google_token.refresh_token.must_equal e.google_token.refresh_token
        a.google_token.access_token.must_equal e.google_token.access_token
        a.google_token.expires_in.must_equal e.google_token.expires_in
        a.google_token.issued_at.must_equal e.google_token.issued_at
      end
    end
  end
end
