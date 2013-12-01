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
		end

		it "builds new google token if everything is OK" do
      @auth.expects(:fetch_access_token)
        .returns({"refresh_token" => "abcds",
                  "access_token" => "accessdenied",
                  "expires_in" => 12323,
                  "issued_at" => 7654321098})
        .once

			token = Housekeeper::GoogleService.get_token("1234auth")

			token.refresh_token.must_equal "abcds"
			token.access_token.must_equal "accessdenied"
			token.expires_in.must_equal 12323
			token.issued_at.must_equal Time.at(7654321098)
		end

		it "returns nil if exception is raised" do
			@auth.expects(:fetch_access_token).raises(
        Signet::AuthorizationError.new("Maaan, something went pretty bad.."))

      token = Housekeeper::GoogleService.get_token("1234auth")
      token.must_be_nil
		end
	end
end