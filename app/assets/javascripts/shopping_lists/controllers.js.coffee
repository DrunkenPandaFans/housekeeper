ShoppingListControllers = angular.module 'shoppingListCtrls', ['ngRoute']

ShoppingListDetailCtrl = ($scope, $routeParams, ShoppingList) ->
  $scope.shoppingList = ShoppingList.get(parseInt($routeParams.id))

ShoppingListControllers.controller 'ShoppingListDetailCtrl', ['$scope', '$routeParams', 'ShoppingList', ShoppingListDetailCtrl]
