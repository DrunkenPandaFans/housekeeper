require 'test_helper'

class CircleTest < ActiveSupport::TestCase
  setup do
    Circle.create!(name: "Amazon", description: "Amazon shopping circle")
  end

  test "validate circle" do
    circle = Circle.new(name: "Alza", description: "Friends of shopping on Alza.")
    assert circle.valid?
  end

  test "invalidate circle without name" do
    circle = Circle.new(name: "", description: "Empty circle")
    assert circle.invalid?
  end

  test "invalidate circle with existing name" do
    circle = Circle.new(name: "Amazon", description: "Another amazon shopping circle")
    assert circle.invalid?
  end
end
