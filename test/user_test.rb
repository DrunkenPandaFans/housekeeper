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
end
