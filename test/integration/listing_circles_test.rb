require 'test_helper'

class ListingCirclesTest < ActionDispatch::IntegrationTest
  setup do
    Circle.create!(name: 'Amazon Book club', description: 'Shopping for books on Amazon')
    Circle.create!(name: 'Local Albert shopping', description: 'shopping generics in Albert')
  end

  test 'listing circles' do
    get '/circles'

    assert_equal 200, response.status
    assert_equal Mime[:json], response.content_type

    assert_equal Circle.count, json(response.body).size
  end

  test 'lists circles by name' do
    get '/circles?name=amazon'

    assert_equal 200, response.status
    assert_equal Mime[:json], response.content_type

    assert_equal 1, json(response.body).size
  end
end
