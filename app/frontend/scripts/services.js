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
