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


ShoppingListControllers.controller 'ShoppingListDetailCtrl', ['$scope', '$routeParams', 'ShoppingList', 'Comment', ShoppingListDetailCtrl]
