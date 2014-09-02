ShoppingListServices = angular.module "shoppingListServices", []

ShoppingListServices.factory "ShoppingList", () ->
  shoppingLists =
    query: () -> root.shopping_lists

    get: (id) -> root.shopping_lists.find (sl) -> sl.id == id

    save: (sl) ->
      sl.id = root.shopping_lists.length
      root.shopping_lists[sl.id] = sl

    update: (sl) ->
      original = @get(sl.id)
      index = root.shopping_lists.indexOf original
      root.shopping_lists[index] = sl

    delete: (id) ->
      root.shopping_lists = root.shopping_lists.filter (s) -> s.id != id


shopping_lists = [
  {
    id: 1
    title: "test"
    description: "testing shopping lists"
    deadline: "2014-12-12"
    moderator: { id: 1, name: "Jan Ferko" },
    items: [
      { id: 2, name: "Clojure in Action", amount: 1, price: 0, created_at: "2014-09-11 14:50" },
      { id: 3, name: "Elloquent Ruby", amount: 1, price: 0, created_at: "2014-10-11 15:20" }
    ]
    comments: [
      { id: 4, text: "This shopping list is for testing only", author: {id: 1, name: "Jan Ferko" }, posted_at: "2014-09-12 14:50"},
      { id: 3, text: "Got it", author: { id: 2, name: "Sue Ferkova"}, posted_at: "2014-10-11 15:20"}
    ]
  }, {
    id: 2,
    title: "test2",
    description: "testing shopping list 2",
    deadline: "2015-01-01",
    moderator: { id: 2, name: "Sue Ferkova" },
    items: [
      { id: 3, name: "Learn yourself some Haskell for greater good", author: {id: 1, name: "Jan Ferko" }, created_at: "2014-08-12 15:43:20"},
      { id: 5, name: "War and Peace", author: { id: 2, name: "Sue Ferkova" }, created_at: "2014-08-12 06:24:34"}
    ],
    comments: []
  }
]

root = exports ? this
unless root.shopping_lists
  root.shopping_lists = shopping_lists
