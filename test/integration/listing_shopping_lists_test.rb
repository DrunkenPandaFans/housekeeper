require 'test_helper'

class ListingShoppingListsTest < ActionDispatch::IntegrationTest
  setup do
    Circle.create!(name: 'Amazon Book club', description: 'Shopping for books on Amazon')
    Circle.create!(name: 'Local Albert shopping', description: 'shopping generics in Albert')
  end

  test 'listing circles' do
    get '/circles'

    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type

    assert_equal Circle.count, JSON.parse(response.body).size
  end

  test 'lists circles by name' do
    get '/circles?name=amazon'

    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type

    assert_equal 1, JSON.parse(response.body).size
  end
end
