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


App.controller 'HomeCtrl', ["$scope", HomeCtrl]
App.controller 'CircleHomeCtrl', ["$scope", "$routeParams", CircleHomeCtrl]

router = ($routeProvider) ->
  $routeProvider.when '/home', {
    templateUrl: '../assets/home.html',
    controller: 'HomeCtrl'
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
  shopping_lists: [
    {name: "Amazon Xmas shopping", description: "To buy stuff from Amazon right before xmas"},
    {name: "Random amazon shopping", description: "Random amazon stuff for greater good"}
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
  shopping_list: [
    {name: "Shopping list for July 7th", description: "All stuff for house for deadline on July 7th"}
  ],
  members: [
    {name: "Katka", email: "katka@email.com", is_moderator: true, image: "http://awesomeurl.com/katka.png"},
    {name: "Sue", email: "sue@email.com", is_moderator: true, image: "http://awesomeurl.com/sue.png"}
  ]
}]
