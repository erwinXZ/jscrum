var app = angular.module('jscrumApp.adminCtrl',["ngStorage"]);

app.controller('adminCtrl', ['$scope','$window','$sessionStorage',function($scope,$window,$sessionStorage){
	
    $scope.admin = "Hola admin";
    $scope.data = $sessionStorage.data;
    data = $scope.data;
}])