var app = angular.module('jscrumApp.usersCtrl',["ngStorage"]);

app.controller('usersCtrl', ['$scope','usuarioServices','$window','$sessionStorage' ,function($scope,usuarioServices,$window,$sessionStorage){
	

    $scope.user = "Vista usuario";
    $scope.data = $sessionStorage.data;
    data = $scope.data;
    $scope.user.visible = false;
    $scope.user.respuesta = "";
    $scope.listar = function(){
        
			// console.log(user);
            console.log($scope.user.visible);
            $scope.user.visible = true;
			usuarioServices.listar().then(function(){
				$scope.response = usuarioServices.response;
                console.log($scope.response);
			});
    }

    $scope.listar();


}])
