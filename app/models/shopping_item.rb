module Housekeeper
  class ShoppingItem
    
    # Public: The name of shopping item.    
    attr_accessor :name

    # Public: The amout to be bought.
    attr_accessor :amount

    # Public: The identifier of user, that requested item.
    attr_accessor :requestor

    # Public: Initializes a shopping item.
    #
    # name: The String name of shopping item. Defaul value is Unknown.
    # requestor: The String identifier of user, that requests item. Default is "".
    # amount: The Integer amout to be bought. Default is 1.
    def initialize(name = "Unknown", requestor = "", amount = 1)
      @name = name
      @amount = amount
      @requestor = requestor
    end

    # Public: Transforms shopping item to hash.
    #
    # Returns hash that contains attributes of shopping items instance.
    def to_hash
      {"name" => @name,
       "amount" => @amount,
       "requestor" => @requestor}
    end

    # Public: Creates a shopping item from hash.
    #
    # data: The hash containing item attributes values.
    #
    # Returns shopping item from data.
    def self.from_hash(data)
      name = data["name"]
      name = "Unknown" unless name

      requestor = data["requestor"]
      requestor = "" unless requestor

      amount = data["amount"]
      amount = 1 unless amount

      ShoppingItem.new name, requestor, amount
    end

  end
end