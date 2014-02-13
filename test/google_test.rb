require 'test_helper'

describe Housekeeper::GoogleService do
	
	before do
		@auth = mock()
		@client = mock()
		Housekeeper::GoogleService.stubs(:build_client).returns(@client)
		Housekeeper::GoogleService.stubs(:build_auth).returns(@auth)
	end

	describe "get_token" do
		
		before do
			@auth.expects(:code=).with("1234auth")		
      @auth.expects(:grant_type=).with("authorization_code")
		end

		it "builds new google token if everything is OK" do
      @auth.expects(:fetch_access_token)
        .returns({"refresh_token" => "abcds",
                  "access_token" => "accessdenied",
                  "expires_in" => 12323})
        .once

			token = Housekeeper::GoogleService.get_token("1234auth")

			token.refresh_token.must_equal "abcds"
			token.access_token.must_equal "accessdenied"
			token.expires_in.must_equal 12323
      token.issued_at.wont_be_nil
		end

		it "returns nil if exception is raised" do
			@auth.expects(:fetch_access_token).raises(
        Signet::AuthorizationError.new("Maaan, something went pretty bad.."))

      token = Housekeeper::GoogleService.get_token("1234auth")
      token.must_be_nil
		end
	end

  describe "user_info" do

    before do
      @token = Housekeeper::GoogleToken.new "refresh", "access", 3600, 7654321098
    end

    it "returns user profile from plus.people.get for user token" do
      @auth.expects(:update_token!).with(@token.to_hash)
      @client.expects(:authorization=).with(@auth)

      response = mock()
      response.expects(:data).returns({
        "id" => "OctoId",
        "displayName" => "Octocat Octocatus",
        "image" => "http://octo"
      })
      
      peopleMock = mock()
      peopleMock.stubs(:get)

      plusMock = mock()
      plusMock.stubs(:people).returns(peopleMock)
      @client.expects(:discovered_api).with('plus', 'v1').returns(plusMock)
      @client.expects(:execute!).with(plusMock.people.get, {:userId => 'me', :key => Housekeeper::config[:client_id]})
        .returns(response)

      Housekeeper::GoogleService.user_info(@token)
    end
    
  end
end
