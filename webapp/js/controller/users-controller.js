var app = angular.module('jscrumApp.usersCtrl',[]);

app.controller('usersCtrl', ['$scope','userServices','$window' ,function($scope,userServices,$window){
	

    $scope.user = {};

    $scope.user.visible = false;
    $scope.user.respuesta = "";
    $scope.listar = function(){
        
			// console.log(user);
            console.log($scope.user.visible);
            $scope.user.visible = true;
			userServices.listar().then(function(){
				$scope.response = userServices.response;
                
			});
    }

    
}])