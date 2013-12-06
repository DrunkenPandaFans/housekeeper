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
      @token = Housekeeper::GoogleToken.new "refreshthis", "acccess", 12321, 343242
    end

    it "returns user info" do
      expected = {"nickname" => "octocat",
                  "image" => {"url" => "https://magicimage.com/github/octocate"}}
      response = mock()
      response.stubs(:body).returns(expected)
      
      plusMock = mock()
      peopleMock = mock()
      @client.expects(:discover_api).with('plus', 'v1').returns(plusMock)
      plusMock.expects(:people).returns(peopleMock)
      peopleMock.expects(:get).with(:userId => 'me').once
      @client.expects(:execute!).with(plusMock.people.get).returns(expected)

      Housekeeper::GoogleService.user_info(@token).must_equal expected
    end

    it "sets users token" do
      @auth.expects(:update_token!).with(@token.to_hash).once

      Housekeeper::GoogleService.user_info(@token)
    end
    
  end
end
