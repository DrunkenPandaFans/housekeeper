'use strict';

var controllers = angular.module("housekeeperControllers", []);

controllers.controller('UserController', function ($scope, $window, ProfileService) {

    $scope.test = $window.sessionStorage.token !== null;

    $scope.disconnect = function () {
        ProfileService.disconnect().then(function () {
            $scope.userProfile = {};
            $scope.hasUserProfile = false;
            $scope.isSignedIn = false;
            $scope.immediateFailed = true;
        });

        delete $window.sessionStorage.token;
    };

    $scope.signedIn = function (profile) {
        $scope.userProfile = profile;
        $scope.hasUserProfile = true;
        $scope.isSignedIn = true;
        $scope.immediateFailed = false;

        // Save user access token to session
        $window.sessionStorage.token = profile.token
    };

    $scope.signIn = function (authData) {
        $scope.$apply(function () {
            $scope.processAuthentication(authData);
        });
    }

    $scope.processAuthentication = function (authResults) {
        $scope.immediateFailed = false;
        if ($scope.isSignedIn) {
            return;
        }

        if (authResults["access_token"]) {
            // authorize on server and create session
            ProfileService.connect(authResults).then(function (profile) {
                $scope.signedIn(profile);
            });
        } else if (authResults["error"] === 'immediate_failed') {
            $scope.immediateFailed = true;
        } else {
            $('#notifier').addClass("error").html("Oopps!! Something went wrong. Please, try again!!");
        }
    }

    $scope.renderSignInButton = function () {
        gapi.signin.render('gsignin', {
            "callback": $scope.signIn,
            "clientid": "541401950578.apps.googleusercontent.com",
            "theme": "dark",
            "cookiepolicy": "single_host_origin",
            "scope": "https://www.googleapis.com/auth/plus.login email profile"            
        });
    }

    function init() {
        $scope.userProfile = {};
        $scope.hasUserProfile = false;
        $scope.isSignedIn = false;
        $scope.hideImmediately = true;

        $scope.renderSignInButton();
    };

    init();
});

controllers.controller('CirclesListController', function ($scope, $window, CircleService) {    

    CircleService.all().success(function(data) {
        $scope.circles = data["circles"];
        $scope.hasCircles = $scope.circles.length > 0;        
    }).error(function(error) {
        $scope.error = error.body;
        $scope.circles = [];
        $scope.hasCircles = false;
    });

    $scope.removeCircle = function(circle) {
        if (!circle.is_moderator) {
            $scope.errorMessage = "You are not moderator of this circle, so you can't remove it.";
            return;
        }

        CircleService.remove(circle.id).success(function() {
            $scope.infoMessage = "Circle was successfully removed.";
        }).error(function(error) {
            $scope.errorMessage = error;
        })
    }

    $scope.isLoggedIn = ($window.sessionStorage.token !== null);      
    
});

controllers.controller('AddCircleController', function($scope, $location, $window, CircleService, UserService) {
   
    UserService.all().success(function (data) {
        $scope.users = data;
    }).error(function(error) {
        $scope.errorMessage = error;
    });

    $scope.hasError = function() {
        $scope.errorMessage !== null && $scope.errorMessage !== "";
    }    

    $scope.circle = {
        "name": "",
        "description": "", 
        "members": []
    };

    $scope.newMember = {
        "id": "",
        "email": ""
    };

    $scope.addMember = function() {
         var id = $scope.newMember.id
         if (id !== null && id !== "") {
             var copy = angular.copy($scope.newMember);
             $scope.circle.members.push(copy);
             $scope.newMember.id = "";
             $scope.newMember.email = "";
         }
     };

    $scope.removeMember = function(member) {
      var members = $scope.circle.members;
      for (var i = 0; i < members.length; i++) {
        if (members[i] == member) {
          members.splice(i, 1);
        }
      }
    }

    $scope.submit = function() {
        if ($scope.circle.name === null || $scope.circle.name === "") {
            // show error
            $scope.errorMessage = "Name is required. Please select name of circle.";
            return;
        }

        var membersIds = [];
        angular.forEach($scope.circle.members, function(member) {
          membersIds.push(member.id);
        });

        var circleData = {
          "name": $scope.circle.name,
          "description": $scope.circle.description,
          "members": $scope.circle.membersIds
        }

        CircleService.create(circleData).success(function() {
            $scope.infoMessage = "Circle successfully created."
            $location.path("/circle");
        }).error(function(error) {
            $scope.errorMessage = error.body;
        })
    }
});

controllers.controller('EditCircleController', function($scope, $location, $routeParams, CircleService) {
    CircleService.find($routeParams.circleId).success(function(data) {
        $scope.circle = data;        
    }).error(function(error) {
        $scope.errorMessage = error.body;
    });

    $scope.submit = function() {
        if ($scope.circle.name === null || $scope.circle.name === "") {
            // show error
            $scope.errorMessage = "Name is required. Please select name of circle.";
            return;
        }

        CircleService.update($scope.circle).success(function(data) {
            $scope.infoMessage = "Circle successfully created.";
            $location.path("/circle");
        }).error(function(error) {
            $scope.errorMessage = error.body;
        })
    }
});
