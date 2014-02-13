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

services.factory("authInterceptor", function($rootScope, $q, $window) {
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
                // show user login necessary message
            }

            return response || $q.when(response);
        }
    }
});

services.config(function ($httpProvider) {
    $httpProvider.interceptors.push("authInterceptor");
});