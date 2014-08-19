App = angular.module('housekeeperApp', ['circles', 'ngRoute'])

router = ($routeProvider) ->
  $routeProvider.when '/home', {
    templateUrl: '../assets/home.html',
    controller: 'CircleHomeCtrl'
  }
  $routeProvider.when '/circle/new', {
    templateUrl: '../assets/circle-create.html',
    controller: 'CircleCreationCtrl'
  }
  $routeProvider.when '/circle/:id/edit', {
    templateUrl: '../assets/circle-create.html',
    controller: 'CircleUpdateCtrl'
  }
  $routeProvider.when '/circle/:id', {
    templateUrl: '../assets/circle.html',
    controller: 'CircleDetailCtrl'
  }
  $routeProvider.otherwise { redirectTo: '/home' }

App.config ['$routeProvider', router]
