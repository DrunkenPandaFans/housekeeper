'use strict';

var controllers = angular.module("housekeeperControllers", []);

controllers.controller('UserController', function($scope, ProfileService) {  

  $scope.disconnect = function() {
    ProfileService.disconnect.then(function() {
      $scope.userProfile = {};
      $scope.hasUserProfile = false;
      $scope.isSignedIn = false;
      $scope.hideImmediately = false;
    });
  };

  $scope.signedIn = function(profile) {
    $scope.userProfile = profile;
    $scope.hasUserProfile = true;
    $scope.isSignedIn = true;
    $scope.hideImmediately = true;
  };

  $scope.signIn = function(authData)  {
    $scope.$apply(function() {
      $scope.processAuthentication(authData);
    });
  }

  $scope.processAuthentication = function(authResults) {
    if ($scope.isSignedIn) {
      return;
    }

    if (authResults["access_token"]) {
      // authorize on server and create session
      ProfileService.connect(authResults).then(function(profile) {
        $scope.signedIn(profile);
      });
    } else if (authResults["error"]) {
       $('#notifier').addClass("error").html("Oopps!! Something went wrong. Please, try again!!");
    }
  }

  $scope.renderSignInButton = function() {
    gapi.signin.render('gsignin', {
      "callback": $scope.signIn,
      "clientid": "541401950578.apps.googleusercontent.com",
      "theme": "dark",
      "cookiepolicy": "single_host_origin",
      "scopes": "https://www.googleapis.com/auth/plus.login",
      'requestvisibleactions': 'http://schemas.google.com/AddActivity',
    });
  }
   
  function init() {
    $scope.userProfile = {};
    $scope.hasUserProfile = false;
    $scope.isSignedIn = false;
    $scope.hideImmediately = false;
    
    $scope.renderSignInButton();    
  };

  init();
});
