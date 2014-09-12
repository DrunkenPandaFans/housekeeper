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
    ShoppingList.update(shoppingList)

    circleId = $routeParams.circleId
    $scope.shoppingList = {}
    $location.path("/circle/" + circleId + "/shopping-list/" + shoppingList.id)

  $scope.back = () ->
    $location.path("/circle/" + $routeParams.circleId + "/shopping-list/" + $routeParams.id)

ShoppingListCreateCtrl = ($scope, $routeParams, $location, ShoppingList) ->
  $scope.submit = (shoppingList) ->
    shoppingList.moderator = {id: 1, name: 'Test'}
    shoppingList.items = []
    shoppingList.comments = []
    shoppingList.circle_id = parseInt($routeParams.id)

    ShoppingList.save(shoppingList)

    $scope.shoppingList = {}
    $location.path("/circle/" + $routeParams.id + "/shopping-list/" + shoppingList.id)

  $scope.back = () ->
    $location.path("/circle/" + $routeParams.circleId)


ShoppingListControllers.controller 'ShoppingListDetailCtrl', ['$scope', '$routeParams', 'ShoppingList', 'Comment', ShoppingListDetailCtrl]
ShoppingListControllers.controller 'ShoppingListEditCtrl', ['$scope', '$routeParams', '$location', 'ShoppingList', ShoppingListEditCtrl]
ShoppingListControllers.controller 'ShoppingListCreateCtrl', ['$scope', '$routeParams', '$location', 'ShoppingList', ShoppingListCreateCtrl]
