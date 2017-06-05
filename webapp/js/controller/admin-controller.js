var app = angular.module('jscrumApp.adminCtrl',["ngStorage"]);

app.controller('adminCtrl', ['$scope','$window','$sessionStorage','userServices',function($scope,$window,$sessionStorage,userServices){
	$scope.user = {};
    $scope.data = $sessionStorage.data;
    data = $scope.data;
    $scope.user.visible = false;
    $scope.user.respuesta = "";
    $scope.listar = function(){
        
			// console.log(user);
            console.log($scope.user.visible);
            $scope.user.visible = true;
			userServices.listar().then(function(){
				$scope.response = userServices.response;
                console.log($scope.response);
			});
    }

    $scope.listar();
    
    
    $scope.mostrarModal = function(user){
        console.log(user);
        $("#modificarModal").modal();
    }
}])