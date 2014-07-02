require 'test_helper'

class UpdateUserTest < ActionDispatch::IntegrationTest
  setup do
    @jan = User.create!(name: "Jan",
                        email: "jan@email.com",
                        token: "abcdefg1234",
                        image: "http://awesomeurl.com/jan.png",
                        send_sms: true)
    @update_data = {
      name: "Octocat", email: "octocat@email.com",
      image: "http://awesomeurl.com/octocat.png",
      send_sms: false}
  end

  test "update authenticated user" do
    patch '/user', @update_data, {"Authorization" => token_auth(@jan.token)}

    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type

    @jan.reload

    assert_equal "Octocat", @jan.name
    assert_equal "octocat@email.com", @jan.email
    assert_equal "http://awesomeurl.com/octocat.png", @jan.image
    assert !@jan.send_sms
  end

  test "update unauthenticated user" do
    patch '/user', @update_data

    assert_equal 401, response.status
    assert_equal Mime::JSON, response.content_type

    error = json(response.body)
    assert "Bad credentials.", error[:error]
  end

  test "update user token" do
    patch '/user', {token: 'newtoken'}, {"Authorization" => token_auth(@jan.token)}

    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type

    assert_equal "abcdefg1234", @jan.reload.token
  end

  test "update with empty email" do
    patch '/user', {email: ''}, {"Authorization" => token_auth(@jan.token)}

    assert_equal 422, response.status
    assert_equal Mime::JSON, response.content_type
  end
end
