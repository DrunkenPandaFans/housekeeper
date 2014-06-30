require 'test_helper'

class CircleTest < ActiveSupport::TestCase
  setup do
    Circle.create!(name: "Amazon", description: "Amazon shopping circle")
  end

  test "save circle without name" do
    circle = Circle.new(name: "", description: "Empty circle")
    assert circle.invalid?
  end

  test "save circle with existing name" do
    circle = Circle.new(name: "Amazon", description: "Another amazon shopping circle")
    assert circle.invalid?
  end
end
