ShoppingListControllers = angular.module 'shoppingListCtrls', ['ngRoute']

ShoppingListDetailCtrl = ($scope, $routeParams, ShoppingList, Comment) ->
  $scope.shoppingList = ShoppingList.get(parseInt($routeParams.id))

  $scope.sendComment = (newComment) ->
    Comment.create(newComment, $scope.shoppingList.id)
    $scope.newComment = {}
    # add to model on success and notify

  $scope.addItem = (item) ->
    ShoppingList.addItem(item, $scope.shoppingList.id)
    $scope.newItem = {}
    # add to model and notify

ShoppingListEditCtrl = ($scope, $routeParams, $location, ShoppingList) ->
  $scope.shoppingList = ShoppingList.get(parseInt($routeParams.id))

  $scope.submit = (shoppingList) ->
    shoppingList.id = parseInt($routeParams.id)
    shoppingList.moderator = { id: 1, name: "Test test" }
    shoppingList.circle_id = parseInt($routeParams.circleId)
    ShoppingList.update(shoppingList)

    circleId = $routeParams.circleId
    $location.path("/circle/" + circleId + "/shopping-list/" + shoppingList.id)

  $scope.back = () -> $location.path("/circle/" + $routeParams.circleId)


ShoppingListControllers.controller 'ShoppingListDetailCtrl', ['$scope', '$routeParams', 'ShoppingList', 'Comment', ShoppingListDetailCtrl]
ShoppingListControllers.controller 'ShoppingListEditCtrl', ['$scope', '$routeParams', '$location', 'ShoppingList', ShoppingListEditCtrl]
