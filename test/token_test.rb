require 'test_helper'

describe Housekeeper::GoogleToken do

  subject do
    Housekeeper::GoogleToken.new "abc123432fdsa", "bvcdsads", 3600, Time.new(2014, 2, 1)
  end

  describe "create" do

    it "creates GoogleToken from hash" do
      data = {"access_token" => "abc123432fdsa",
              "refresh_token" => "bvcdsads",
              "expires_in" => 3600,
              "issued_at" => Time.new(2014, 2, 1)}

      token = Housekeeper::GoogleToken.create(data)
      token.access_token.must_equal data["access_token"]
      token.refresh_token.must_equal data["refresh_token"]
      token.expires_in.must_equal data["expires_in"]
      token.issued_at.must_equal data["issued_at"]
    end

  end

  describe "to_hash" do
    
    it "transforms token to hash, that contains all attributes" do      
      data = subject.to_hash
      data["access_token"].must_equal subject.access_token
      data["refresh_token"].must_equal subject.refresh_token
      data["expires_in"].must_equal subject.expires_in
      data["issued_at"].must_equal subject.issued_at  
    end

  end

  describe "expired?" do
    
    it "returns true if issued_at + expires_in < Time.now" do      
      subject.expired?.must_equal true
    end

    it "returns true if issued_at + expires_in = Time.now" do
      subject.expired?.must_equal true
    end

    it "returns false if issued_at + expires_in > Time.now" do
      subject.issued_at = Time.now + 3600
      subject.expired?.must_equal false
    end

  end

end