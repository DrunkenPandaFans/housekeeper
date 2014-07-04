require 'test_helper'

class OtherUserProfileTest < ActionDispatch::IntegrationTest
  setup do
    @jan = User.create!(name: 'Jan', email: 'jan@drunkenpanda.com', token: '123456abcdefg', send_sms: false,
      image: 'http://someawesomeimages.com/jan.png')
    User.create!(name: 'Octocat', email: 'octocat@github.com', token: 'abcde', send_sms: false,
      image: 'http://github.com/images/octocat.png')
  end

  test "get profile of different user" do
    get "/users/#{@jan.id}", {}, 
      {"Authorization" => token_auth("abcde")}

    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type

    user = json(response.body)
    assert_equal @jan.name, user[:name]
  end

  test "get profile of user without authentication" do
    get "/users/#{@jan.id}"

    assert_equal 401, response.status
    assert_equal Mime::JSON, response.content_type

    error = json(response.body)
    assert_equal "Bad credentials.", error[:error]
  end

  test "get profile of nonexistent user" do
    get "/users/-12323", {},
      {"Authorization" => token_auth(@jan.token)}

    assert_equal 404, response.status
    assert_equal Mime::JSON, response.content_type

    error = json(response.body)
    assert_equal "User not found.", error[:error]
  end 
end
