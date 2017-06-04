var app = angular.module('jscrumApp.registroCtrl',[]);

app.controller('registroCtrl', ['$scope', function($scope){
	
    $scope.registro = "Este es el registro";
    $scope.user = {};
    $scope.user.name = "";
    $scope.user.lasname = "";
    $scope.user.email = "";
    $scope.user.nick = "";
    $scope.user.password = "";
    $scope.user.profession = "";

    $scope.registrar = function(){
        console.log($scope.user);  
    }

    
}])