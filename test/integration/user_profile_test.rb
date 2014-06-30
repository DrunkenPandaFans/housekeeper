require 'test_helper'

class UserProfileTest < ActionDispatch::IntegrationTest
  setup do
    @jan = User.create!(name: 'Jan', email: 'jan@drunkenpanda.com', token: '123456abcdefg', send_sms: false,
      image: 'http://someawesomeimages.com/jan.png')
    User.create!(name: 'Octocat', email: 'octocat@github.com', token: 'abcde', send_sms: false,
      image: 'http://github.com/images/octocat.png')
  end

  test "get authenticated user profile" do
    get '/user', {}, {"Authorization" => "Token token=#{@jan.token}"}

    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type

    assert_equal @jan.id, json(response.body)[:id]
  end

  test "get user profile without authorization token" do
    get '/user'

    assert_equal 401, response.status
    assert_equal Mime::JSON, response.content_type

    assert_equal "Bad credentials", json(response.body)
  end

  test "get profile of different user" do
    get "/users/#{@jan.id}", {}, {"Authorization" => "Token token=abcde"}

    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type

    assert_equal @jan.name, json(response.body)[:name]
  end

  test "get profile of user without authentication" do
    get "/users/octocat"

    assert_equal 401, response.status
    assert_equal Mime::JSON, response.content_type

    assert_equal "Bad credentials", json(response.body)
  end
end
