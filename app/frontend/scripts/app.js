app = angular.module("housekeeperApp", 
    ["ngRoute", "ui.bootstrap", "housekeeperServices", 
     "housekeeperControllers"]);

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
        .when("/circles/:circleId/", {
            templateUrl: "partials/circle-detail.html",
            controller: "CircleDetailController"
        })
        .when("/circles/:circleId/shopping-list/add", {
            templateUrl: "partials/shopping-list-form.html",
            controller: "AddShoppingListController"
        })
        .when("/", {
            templateUrl: "partials/intro.html",
        })
        .otherwise({
            redirectTo: '/'
        })
}]);

app.run(function($rootScope, $location, $window) {
    $rootScope.$on('$routeChangeStart', function(event, next, current) {
        if ($window.sessionStorage.token == null) {
            if (next.templateUrl !== 'partials/intro.html') {
                $location.path('/');
            }
        }
    });    
});