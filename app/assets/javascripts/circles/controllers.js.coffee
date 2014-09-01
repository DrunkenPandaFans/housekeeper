CircleControllers = angular.module("circleControllers", ["ngRoute", "flash"]);

CircleHomeCtrl = ($scope, Circle) ->
 $scope.circles = Circle.query()

CircleDetailCtrl = ($scope, $routeParams, $location, Circle) ->
  $scope.circle = Circle.get(parseInt($routeParams.id))

  $scope.remove = (id) ->
    Circle.remove(id)
    $location.path('/home')

  $scope.hasShoppingLists = ->
    $scope.circle.shopping_lists.length != 0

CircleCreationCtrl = ($scope, $location, Circle) ->
  $scope.submit = (circle) ->
    Circle.save circle
    $location.path('/home')

CircleUpdateCtrl = ($scope, $routeParams, $location, flash, Circle) ->
  $scope.circle = Circle.get(parseInt($routeParams.id))
  $scope.submit = (circle) ->
    Circle.update circle
    flash('success', 'Circle was successfully created')
    $location.path('/home')

CircleControllers.controller 'CircleHomeCtrl', ["$scope", "Circle", CircleHomeCtrl]
CircleControllers.controller 'CircleDetailCtrl', ["$scope", "$routeParams", "$location", "Circle", CircleDetailCtrl]
CircleControllers.controller 'CircleCreationCtrl', ["$scope", "$location", "Circle", CircleCreationCtrl]
CircleControllers.controller 'CircleUpdateCtrl', ["$scope", "$routeParams", "$location", "flash", "Circle", CircleUpdateCtrl]
