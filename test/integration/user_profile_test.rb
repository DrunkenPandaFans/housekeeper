require 'test_helper'

class UserProfileTest < ActionDispatch::IntegrationTest
  setup do
    @jan = User.create!(name: 'Jan', email: 'jan@drunkenpanda.com', token: '123456abcdefg', send_sms: false,
      image: 'http://someawesomeimages.com/jan.png')
  end

  test "get authenticated user profile" do
    get '/user', params: {"Authorization" => token_auth(@jan.token)}

    assert_equal 200, response.status
    assert_equal Mime[:json], response.content_type

    assert_equal @jan.id, json(response.body)[:id]
  end

  test "get user profile without authorization token" do
    get '/user'

    assert_equal 401, response.status
    assert_equal Mime[:json], response.content_type

    error = json(response.body)
    assert_equal "Bad credentials.", error[:error]
  end

end
