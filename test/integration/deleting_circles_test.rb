require 'test_helper'

class DeletingCirclesTest < ActionDispatch::IntegrationTest
  setup do
    @circle = Circle.create!(name: "Amazing circle",
                   description: "My amazing shopping circle")
  end

  test "delete circle" do
    delete "/circles/#{@circle.id}"

    assert_equal 204, response.status
  end

  test "delete nonexisting circle" do
    delete "/circles/-1"

    assert_equal 404, response.status
  end
end
