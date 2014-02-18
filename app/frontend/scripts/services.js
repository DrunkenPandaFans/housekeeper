'use strict';

var services = angular.module("housekeeperServices", []);

services.factory("ProfileService", function ($http) {
    var profileService = {};


    profileService.connect = function (authData) {
        return $http.post('/connect', authData);
    };

    profileService.disconnect = function () {
        return $http.post('/disconnect');
    };

    return profileService;
});

services.factory("UserService", function ($http) {
    var userService = {};

    userService.all = function() {
        return $http.get("/user");
    };

    userService.find = function(userId) {
        return $http.get("/user/" + userId);
    };
    return userService;
});

services.factory("CircleService", function ($http) {
    var circlesService = {};

    circlesService.all = function () {
        return $http.get('/circle');
    }

    circlesService.find = function(id) {
        return $http.get('/circle/' + id);
    }

    circlesService.create = function(data) {
        return $http.post("/circle", data)
    }

    circlesService.update = function(data) {
        return $http.put("/circle/" + data.id, data)
    }

    circlesService.remove = function(circleId) {
        return $http.delete("/circle/" + circleId);
    }

    return circlesService;
    
});

services.factory("authInterceptor", function($q, $window, $location) {
    return {
        request: function(config) {
            config.headers = config.headers || {};
            if ($window.sessionStorage.token) {
                config.headers.Authorization = "Bearer " + $window.sessionStorage.token;
            }
            return config;
        },

        response: function(response) {
            if (response.status === 401) {
                $location.path('/');
            }

            return response || $q.when(response);
        }
    }
});

services.config(function ($httpProvider) {
    $httpProvider.interceptors.push("authInterceptor");
});
