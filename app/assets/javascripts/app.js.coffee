App = angular.module('housekeeperApp', ['circles', 'shoppingLists', 'ngRoute'])

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
  $routeProvider.when '/circle/:circleId/shopping-list/:id', {
    templateUrl: '../assets/shopping_list.html',
    controller: 'ShoppingListDetailCtrl'
  }
  $routeProvider.otherwise { redirectTo: '/home' }

App.config ['$routeProvider', router]
