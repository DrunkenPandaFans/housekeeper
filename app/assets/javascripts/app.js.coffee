App = angular.module('housekeeperApp', ['ngRoute'])

HomeCtrl = ($scope) ->
 $scope.message = "Hello world"
 $scope.circles = circles

App.controller 'HomeCtrl', ["$scope", HomeCtrl]

router = ($routeProvider) ->
  $routeProvider.when '/home', {
    templateUrl: '../assets/home.html',
    controller: 'HomeCtrl'
  }
  $routeProvider.otherwise { redirectTo: '/home' }

App.config ['$routeProvider', router]


circles = [{id: 1, name: "Amazon circle", description: "Circle for amazon shopping lists"},
  {id: 2, name: "Albert", description: "Shopping for generic albert stuff"},
  {id: 3, name: "My household shopping", description: "Shopping for my household."}]
