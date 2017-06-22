var app = angular.module('jscrumApp.sprintCtrl',["ngStorage"]);

app.controller('sprintCtrl', ['$scope','sprintServices','$window','$sessionStorage' ,function($scope,sprintServices,$window,$sessionStorage){
	

    $scope.sprint = "Sprint";
    $scope.dataSprint = $sessionStorage.sprint;


    
}])