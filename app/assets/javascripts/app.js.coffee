App = angular.module('housekeeperApp', ['ngRoute'])

HomeCtrl = ($scope) ->
 $scope.message = "Hello world"

App.controller 'HomeCtrl', ["$scope", HomeCtrl]

router = ($routeProvider) ->
  $routeProvider.when '/home', {
    templateUrl: '../assets/home.html',
    controller: 'HomeCtrl'
  }
  $routeProvider.otherwise { redirectTo: '/home' }

App.config ['$routeProvider', router]
