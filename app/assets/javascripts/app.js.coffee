App = angular.module('housekeeperApp', ['ngRoute'])

HomeCtrl = ($scope) ->
 $scope.message = "Hello world"
 $scope.circles = circles

 $scope.formIsShown = false

 $scope.showCircleForm = ->
  $scope.formIsShown = !$scope.formIsShown

 $scope.addCircle = ->
  circles.push {name: $scope.name, description: $scope.description}
  delete $scope.name
  delete $scope.description

CircleHomeCtrl = ($scope, $routeParams) ->
 for c in circles
   if c.id == parseInt($routeParams.id)
     $scope.circle = c
     break

CircleCreationCtrl = ($scope, $location) ->
  $scope.submit = ->
    # call service instead
    circles.push($scope.circle)
    $location.path('/home')

CircleUpdateCtrl = ($scope, $routeParams, $location) ->
  for c in circles
    if c.id == parseInt($routeParams.id)
      $scope.circle = c
      break

  $scope.submit = ->
    # call service instead
    circles.push($scope.circle)
    $location.path('/home')

App.controller 'HomeCtrl', ["$scope", HomeCtrl]
App.controller 'CircleHomeCtrl', ["$scope", "$routeParams", CircleHomeCtrl]
App.controller 'CircleCreationCtrl', ["$scope", "$location", CircleCreationCtrl]
App.controller 'CircleUpdateCtrl', ["$scope", "$routeParams", "$location", CircleUpdateCtrl]

router = ($routeProvider) ->
  $routeProvider.when '/home', {
    templateUrl: '../assets/home.html',
    controller: 'HomeCtrl'
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
    controller: 'CircleHomeCtrl'
  }
  $routeProvider.otherwise { redirectTo: '/home' }

App.config ['$routeProvider', router]


circles = [{
  id: 1,
  name: "Amazon circle",
  description: "Circle for amazon shopping lists",
  logo: "http://www.turnerduckworth.com/media/filer_public/b4/ac/b4ac5dfe-b335-403c-83b2-ec69e01f94e6/td-amazon-hero.svg",
  shopping_lists: [
    {name: "Amazon Xmas shopping", description: "To buy stuff from Amazon right before xmas", deadline: "2014-12-15"},
    {name: "Random amazon shopping", description: "Random amazon stuff for greater good", deadline: "2015-01-01"}
  ],
  members: [
    {name: "Jan", email: "jan@email.com", is_moderator: true, image: "http://awesomeurl.com/jan.png"},
    {name: "Sue", email: "sue@email.com", is_moderator: false, image: "http://awesomeurl.com/sue.png"}
  ]
},
{
  id: 2,
  name: "Albert",
  description: "Shopping for generic albert stuff",
  logo: "http://www.albert.cz/-a7643?field=data",
  shopping_lists: [],
  members: [
    {name: "Jan", email: "jan@email.com", is_moderator: false, image: "http://awesomeurl.com/jan.png"},
    {name: "Anka", email: "anka@email.com", is_moderator: true, image: "http://awesomeurl.com/anka.png"}
  ]
},
{
  id: 3,
  name: "My household shopping",
  description: "Shopping for my household.",
  logo: "http://www.fireinspiration.com/wp-content/uploads/logo/logo_40.jpg",
  shopping_list: [
    {name: "Shopping list for July 7th", description: "All stuff for house for deadline on July 7th", deadline: "2015-02-01"}
  ],
  members: [
    {name: "Katka", email: "katka@email.com", is_moderator: true, image: "http://awesomeurl.com/katka.png"},
    {name: "Sue", email: "sue@email.com", is_moderator: true, image: "http://awesomeurl.com/sue.png"}
  ]
}]
