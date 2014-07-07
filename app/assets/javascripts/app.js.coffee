app = angular.module('housekeeperApp', [])

HomeCtrl = ($scope) ->
 $scope.message = "Hello world"

app.controller 'HomeCtrl', ["$scope", HomeCtrl]

