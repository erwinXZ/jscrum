var app = angular.module('jscrumApp.usersCtrl',["ngStorage"]);

app.controller('usersCtrl', ['$scope','userServices','$window','$sessionStorage' ,function($scope,userServices,$window,$sessionStorage){
	

    $scope.user = "Vista usuario";
    $scope.data = $sessionStorage.data;


}])
