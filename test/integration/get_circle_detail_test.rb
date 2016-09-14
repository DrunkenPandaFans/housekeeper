require 'test_helper'

class GetCircleDetailTest < ActionDispatch::IntegrationTest
  setup do
    @amazon = Circle.create!(name: "Amazon Test circle",
                             description: "My new amazon")
  end

  test "get circle" do
    get "/circles/#{@amazon.id}"

    assert_equal 200, response.status
    assert_equal Mime[:json], response.content_type

    circle = json(response.body)
    assert_equal "Amazon Test circle", circle[:name]
  end

  test "get circle, that does not exist" do
    get "/circles/-1", headers: {"Accept" => "application/json"}

    assert_equal 404, response.status
    assert_equal Mime[:json], response.content_type
  end
end
