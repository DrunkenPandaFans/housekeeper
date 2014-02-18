'use strict';

var controllers = angular.module("housekeeperControllers", []);

controllers.controller('UserController', 
    function ($scope, $window, $location, ProfileService) {

    $scope.disconnect = function () {
        ProfileService.disconnect().then(function () {
            $scope.userProfile = {};
            $scope.hasUserProfile = false;
            $scope.isSignedIn = false;
            $scope.immediateFailed = true;

            delete $window.sessionStorage.token;

            if ($location.path() !== '/') {
                $location.path('/');
            }
        });
    };

    $scope.signedIn = function (profile) {
        $scope.userProfile = profile;
        $scope.hasUserProfile = true;
        $scope.isSignedIn = true;
        $scope.immediateFailed = false;

        // Save user access token to session
        $window.sessionStorage.token = profile.token

        if ($location.path() === '/') {
            $location.path('/circles');
        }
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
                $scope.signedIn(profile.data);
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

controllers.controller('CirclesListController', 
    function ($scope, $window, $location, CircleService) {        

    CircleService.all().success(function(data) {
        $scope.circles = data["circles"];
        $scope.hasCircles = $scope.circles.length > 0;        
    }).error(function(error) {
        $scope.error = error.body;
        $scope.circles = [];
        $scope.hasCircles = false;
    });

    $scope.removeCircle = function(circle) {
        $scope.errorMessage = null;
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

controllers.controller('AddCircleController', 
    function($scope, $location, $window, CircleService, UserService) {    
   
    UserService.all().success(function (data) {
        $scope.users = data;

        // aliasing members array for sake of template
        $scope.membersChanges = $scope.circle.members;        
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
        $scope.errorMessage = null;
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
            $location.path("/circles");
        }).error(function(error) {
            $scope.errorMessage = error.body;
        })
    }
});

controllers.controller('EditCircleController', 
    function($scope, $location, $window, $routeParams, $q, CircleService, UserService) {    
   
    $q.all([CircleService.find($routeParams.circleId), UserService.all()])
    .then(function (resources) {
        var users = resources[1].data;
        var circle = resources[0].data;

        var circleMembers = circle.members;
        for (var i = 0; i < users.length; i++) {
          var user = users[i];
          if (circleMembers.indexOf(user.id) != -1) {
            $scope.membersChanges.push(user);
          }
        }

        $scope.circle = circle;
        $scope.users = users;
    });

    $scope.membersChanges = [];

    $scope.newMember = {
      "id": "",
      "email": ""
    };

    $scope.addMember = function() {      
      var member = angular.copy($scope.newMember);
      if ($scope.membersChanges.indexOf(member) == -1) {
          $scope.membersChanges.push(member);
          $scope.newMember.id = "";
          $scope.newMember.email = "";
      } else {
          $scope.infoMessage = "User is already in circle";
      }
    };

    $scope.removeMember = function(user) {
      var members = $scope.membersChanges;
      for (var i = 0; i < members.length; i++) {
        if (members[i] == user) {
          members.splice(i, 1);
        }
      }
    }

    $scope.submit = function() {
        $scope.errorMessage = null;
        if ($scope.circle.name === null || $scope.circle.name === "") {
            // show error
            $scope.errorMessage = "Name is required. Please select name of circle.";
            return;
        }

        var membersIds = [];
        angular.forEach($scope.membersChanges, function(member) {
          membersIds.push(member.id);
        });
        $scope.circle.members = membersIds;

        CircleService.update($scope.circle).success(function(data) {
            $scope.infoMessage = "Circle successfully created.";
            $location.path("/circles");
        }).error(function(error) {
            $scope.errorMessage = error.body;
        })
    }
});

controllers.controller("CircleDetailController", 
    function($scope, $routeParams, CircleService, UserService) {       

    var circleId = $routeParams.circleId;

    CircleService.find(circleId).success(function(data, status) {
        $scope.circle = data;

        $scope.members = [];
        angular.forEach($scope.circle.members, function (userId) {
            UserService.find(userId).success(function(userData, status) {
                $scope.members.push(userData);
            }).error(function(error) {
                $scope.errorMessage = error;
            });
        });
        angular.forEach($scope.circle.shopping_lists, function(list) {
            var dateString = list.date;
            var date = new Date(dateString);
            list.date = date.getDate() + "." + (date.getMonth() + 1)+ "." + date.getFullYear();
        })
    }).error(function(error) {
        $scope.errorMessage = error;
    });

    $scope.removeCircle = function(circle) {
        $scope.errorMessage = null;
        if (!circle.is_moderator) {
            $scope.errorMessage = "You are not moderator of this circle, so you can't remove it.";
            return;
        }

        CircleService.remove(circle.id).success(function() {
            $scope.infoMessage = "Circle was successfully removed.";
        }).error(function(error) {
            $scope.errorMessage = error;
        })
    };
});

controllers.controller("AddShoppingListController", 
    function($scope, $routeParams, $window, $location, CircleService) {

    $scope.circleId= $routeParams.circleId;    

    $scope.newShoppingList = {
        "date": "",
        "shop": "",
        "items": []
    };

    $scope.newShoppingItem = {
        "amount": 1,
        "name": "",
        "requestor": $window.sessionStorage.token
    }

    $scope.submit = function() {
        $scope.errorMessage = null;
        // validation goes here!!
        var newShoppingList = $scope.newShoppingList;
        if (newShoppingList.shop == null || newShoppingList.shop == "") {
            $scope.errorMessage = "Please, provide name of the shop";
            return;
        }

        if (newShoppingList.date == null || newShoppingList.date == "") {
            $scope.errorMessage = "Please provide shopping date in format: dd.MM.yyyy";
            return;
        }
        var datePattern = /\d{1,2}\.\d{1,2}\.\d{4}/
        if (!newShoppingList.date.match(datePattern)) {
            $scope.errorMessage = "Invalid format date. Please provide shopping date in format: dd.MM.yyyy.";
            return;
        }

        var millis = Date.parse(newShoppingList.date);
        if (isNaN(millis)) {
            $scope.errorMessage = "Invalid format date. Please provide shopping date in format: dd.MM.yyyy.";
            return;
        }

        $scope.newShoppingList.date = new Date(millis).toISOString();        
        
        CircleService.find($scope.circleId).success(function(data) {
            var circle = data;

            if (circle == null || $scope.errorMessage != null) {
                return;
            }

            if (circle.shopping_lists === null || circle.shopping_lists === 'undefined') {
                circle.shopping_lists = [];
            }
            circle.shopping_lists.push($scope.newShoppingList);

            CircleService.update(circle).success(function(data, status) {
                $scope.infoMessage = "Shopping list was successfully added";
                $location.path("/circles/" + $scope.circleId);
            }).error(function(error) {
                $scope.errorMessage = "It was not possible create new shopping list. " + error;
            })
        }).error(function(error) {
            $scope.errorMessage = error;
        });
    };

    // add and remove shopping items to model
    $scope.addShoppingItem = function() {
        if ($scope.newShoppingItem.name == null || $scope.newShoppingItem === "") {
            $scope.errorMessage = "Shopping item name is required. Please, provide name.";
            return;
        }

        var copy = angular.copy($scope.newShoppingItem);
        $scope.newShoppingList.items.push(copy);
        $scope.newShoppingItem.name = "";
        $scope.newShoppingItem.amount = 1;
    };

    $scope.removeShoppingItem = function(item) {
        var shoppingItems = $scope.newShoppingList.items;
        for (var i = 0; i < shoppingItems.length; i++) {
            if (shoppingItems[i] == item) {
                shoppingItems.splice(i, 1);
            }
        }
    }

});