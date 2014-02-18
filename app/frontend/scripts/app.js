app = angular.module("housekeeperApp", ["ngRoute", "housekeeperServices", "housekeeperControllers"]);

app.config(['$routeProvider', 
    function($routeProvider) {
        $routeProvider.when('/circles', {
            templateUrl: "partials/circles-list.html",
            controller: 'CirclesListController'
        })
        .when('/circles/add', {
            templateUrl: "partials/circles-form.html",
            controller: "AddCircleController"
        })
        .when("/circles/edit/:circleId",{
            templateUrl: "partials/circles-form.html",
            controller: "EditCircleController"
        })
        .otherwise({
            redirectTo: '/circles'
        })
}]);