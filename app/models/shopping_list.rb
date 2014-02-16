module Housekeeper
  class ShoppingList
    
    # Public: The date of shopping.
    attr_accessor :date

    # Public: The name of the shop.
    attr_accessor :shop

    # Public: The items on shopping list.
    attr_accessor :items    

    # Public: Initializes a shopping list.
    #
    # date: The Time date of shopping.
    # shop: The String name of the shop.
    # items: The List item on shopping list.
    def initialize(date, shop, items)
      @date = date
      @shop = shop
      @items = items
    end   

    # Public: Transforms shopping list to hash
    #
    # Returns hash that contains attributes of shopping list instance
    def to_hash
      items = @items.map do |item|
        item.to_hash
      end
      
      {"date" => @date,
       "place" => @shop,
       "items" => items}
    end    

    # Public: Checks if shopping list has already been served.
    #
    # Returns true if shopping list has been served, false otherwise.
    def served?
      now = Time.now
      date < now
    end

    # Public: Creates a shopping list from hash.
    #
    # data: The hash contains shopping list attribute values.
    #
    # Returns shopping list created from hash.
    def self.from_hash(data)
      items = data["items"].map do |item|
        ShoppingItem.from_hash(item)
      end
      ShoppingList.new data["date"], data["shop"], items
    end
  end
end