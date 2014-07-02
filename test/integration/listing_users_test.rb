require 'test_helper'

class ListingUsersTest < ActionDispatch::IntegrationTest
  setup do
    User.create!(name: "Jan Ferko", email: "jan@gmail.com",
                 token: "abcdefg", image: "http://awesomeurl.com",
                 send_sms: true)
    User.create!(name: "Octocat The Greatest", email: "octocat@git.com",
                 token: "abcdef", image: "http://git.com/octo.png",
                 send_sms: false)
  end

  test "listing of users without authentication" do
    get "/users"

    assert_equal 401, response.status
    assert_equal Mime::JSON, response.content_type

    error = json(response.body)
    assert_equal "Bad credentials.", error[:error]
  end

  test "listing of users" do
    get "/users", {}, {"Authorization" => token_auth("abcdefg")}

    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type

    users = json(response.body)
    assert_equal 2, users.size
  end

  test "do not send user token in users listing" do
    get "/users", {}, {"Authorization" => token_auth("abcdefg")}

    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type

    users = json(response.body)
    assert users
    users.each { |u| assert u[:token].nil? }
  end
end
