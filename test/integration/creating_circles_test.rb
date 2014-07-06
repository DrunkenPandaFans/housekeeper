require 'test_helper'

class CreatingCirclesTest < ActionDispatch::IntegrationTest
  test 'creates new circles' do
    post '/circles', 
      { name: "New circle",
        description: "New awesome circlel"}.to_json, 
      { "Accept" => "application/json",
        "Content-Type" => "application/json"}

    assert_equal 201, response.status
    assert_equal Mime::JSON, response.content_type

    circle = json(response.body)
    assert_equal api_circle_url(circle[:id]), response.location
  end

  test 'do not create new circle with invalid data' do
    post '/circles', { name: nil, description: 'some description'}.to_json,
      {"Accept" => "application/json",
       "Content-Type" => "application/json"}

    assert_equal 422, response.status
    assert_equal Mime::JSON, response.content_type
  end
end
