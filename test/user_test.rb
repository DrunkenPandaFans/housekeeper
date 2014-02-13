require 'test_helper'

describe Housekeeper::User do
  
  before do
    @db = Housekeeper::mongo["users"]      
  end

  after do
    @db.remove()
  end  

  describe "save" do    

    subject do
      token = Housekeeper::GoogleToken.new "abcsd", "accessthis", 1234, Time.at(765432109)
      Housekeeper::User.new "octo@github.com", token      
    end
    
    it "calls insert on 'users' collection" do            
      saved = subject.save
      expected = @db.find({"_id" => BSON::ObjectId.from_string(saved.id)}).first

      saved.email.must_equal expected["email"]
      saved.send_sms.must_equal expected["send_sms"]
      saved.default_group.must_equal expected["default_group"]
      saved.google_token.access_token.must_equal expected["google_token"]["access_token"]
      saved.google_token.refresh_token.must_equal expected["google_token"]["refresh_token"]
      saved.google_token.issued_at.must_equal Time.at(expected["google_token"]["issued_at"])
      saved.google_token.expires_in.must_equal expected["google_token"]["expires_in"]
    end

    it "returns itself" do      
      subject.save.must_equal subject
    end
  end

  describe "update" do
    subject do
      token = Housekeeper::GoogleToken.new "abcsd", "accessthis", 1234, Time.at(765432109)
      Housekeeper::User.new "octo@github.com", token      
    end

    before do
      subject.save
    end

    it "calls update on 'users' collection" do      
      subject.email = "octocat_mama@github.com"
      subject.google_token.refresh_token = "abcs3d"
      subject.google_token.access_token = "accessthis2"
      subject.google_token.expires_in = 12345
      subject.google_token.issued_at = Time.at(76543209)
      subject.send_sms = true
      subject.default_group = "octocats"

      subject.update      

      expected = @db.find({"_id" => BSON::ObjectId(subject.id)}).first      

      subject.email.must_equal expected["email"]
      subject.send_sms.must_equal expected["send_sms"]
      subject.default_group.must_equal expected["default_group"]
      subject.google_token.access_token.must_equal expected["google_token"]["access_token"]
      subject.google_token.refresh_token.must_equal expected["google_token"]["refresh_token"]
      subject.google_token.issued_at.must_equal Time.at(expected["google_token"]["issued_at"])
      subject.google_token.expires_in.must_equal expected["google_token"]["expires_in"]
    end

    it "returns itself" do
      subject.update.must_equal subject
    end
  end

  describe "find" do        

    before do
      @token = Housekeeper::GoogleToken.new "abcsd", "accessthis", 1234, Time.at(765432109)
      @user = Housekeeper::User.new "octo@github.com", @token, "octocat"
      @user.send_sms = false
      @user.default_group = "octocats"

      @user.save
    end

    it "finds existing user by login" do
      actual = Housekeeper::User.find(@user.id)

      actual.id.must_equal @user.id
      actual.email.must_equal @user.email
      actual.google_token.refresh_token.must_equal @user.google_token.refresh_token
      actual.google_token.access_token.must_equal @user.google_token.access_token
      actual.google_token.expires_in.must_equal @user.google_token.expires_in
      actual.google_token.issued_at.must_equal @user.google_token.issued_at
    end

    it "returns nil if user was not found" do      
      Housekeeper::User.find("52fa9ff331d55b280c000004").must_be_nil
    end

    it "returns user if his login is in uppercase" do      
      actual = Housekeeper::User.find(@user.id.upcase)

      actual.id.must_equal @user.id
      actual.email.must_equal @user.email
      actual.google_token.refresh_token.must_equal @token.refresh_token
      actual.google_token.access_token.must_equal @token.access_token
      actual.google_token.expires_in.must_equal @token.expires_in
      actual.google_token.issued_at.must_equal @token.issued_at
    end
  end

  describe "all" do    

    before do
      token1 = Housekeeper::GoogleToken.new "abcsd", "accessthis", 1234, Time.at(765432109)
      token2 = Housekeeper::GoogleToken.new "devil", "devilentered", 2345, Time.at(9876543)
      user1 = Housekeeper::User.new "octo@github.com", token1
      user2 = Housekeeper::User.new "unicorn@evilplace.com", token2
      
      @users = [user1, user2]      
    end      

    it "returns empty array if no user is in collection" do
      Housekeeper::User.all.must_be_empty
    end

    it "returns all users in collection" do      
      @users.each do |user| 
        user.save 
      end

      actual_users = Housekeeper::User.all
      actual_users.size.must_equal 2           

      actual_users.zip(@users).each do |a, e|
        a.id.must_equal e.id
        a.email.must_equal e.email
        a.google_token.refresh_token.must_equal e.google_token.refresh_token
        a.google_token.access_token.must_equal e.google_token.access_token
        a.google_token.expires_in.must_equal e.google_token.expires_in
        a.google_token.issued_at.must_equal e.google_token.issued_at
      end
    end
  end

  describe "find_by_email" do   

    before do
      token = Housekeeper::GoogleToken.new "abcsd", "accessthis", 1234, Time.at(765432109)
      @user = Housekeeper::User.new "octo@github.com", token

      @user.save
    end

    it "returns user with given email if user is found" do
      actual = Housekeeper::User.find_by_email(@user.email)

      actual.wont_be_nil

      actual.id.must_equal @user.id
      actual.email.must_equal @user.email
      actual.google_token.access_token.must_equal @user.google_token.access_token
      actual.google_token.refresh_token.must_equal @user.google_token.refresh_token
      actual.google_token.issued_at.must_equal @user.google_token.issued_at
      actual.google_token.expires_in.must_equal @user.google_token.expires_in
    end

    it "returns nil if there is no user with given email" do
      actual = Housekeeper::User.find_by_email("octo_mama@github.com")
      actual.must_be_nil
    end

    it "ignores uppercase" do
      actual =Housekeeper::User.find_by_email(@user.email.upcase)

      actual.wont_be_nil

      actual.id.must_equal @user.id
      actual.email.must_equal @user.email
      actual.google_token.access_token.must_equal @user.google_token.access_token
      actual.google_token.refresh_token.must_equal @user.google_token.refresh_token
      actual.google_token.issued_at.must_equal @user.google_token.issued_at
      actual.google_token.expires_in.must_equal @user.google_token.expires_in
    end
  end
end
