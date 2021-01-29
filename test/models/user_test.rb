require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    User.create!(name: "Jan", email: "jan@drunkenpanda.com", token: "abcdefg",
      image: "http://awesomeimage.com/image.png", send_sms: false)
  end

  test "validate user with duplicated email" do
    user = User.new(name: "Jan", email: "jan@drunkenpanda.com", token: "abcdefg",
      image: "http://awesome", send_sms: false)
    assert user.invalid?
  end

  test "validate user without email" do
    user = User.new(name: "Jan", token: "abcdefg", image: "http://awesome.com", send_sms: false)
    assert user.invalid?
  end

  test "validate user without token" do
    user = User.new(name: "Jan", email: "jan@email.cz", image: "http://awesome.com", send_sms: true)
    assert user.invalid?
  end

  test "validate user with duplicated token" do
    user = User.new(name: "Jan", email: "jan@email.cz", image: "http://awesome.com",
      token: "abcdefg", send_sms: true)
    assert user.invalid?
  end
end
