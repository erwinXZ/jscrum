var app = angular.module('jscrumApp.registroCtrl',[]);

app.controller('registroCtrl', ['$scope','userServices' ,function($scope,userServices){
	
    // $scope.registro = "Este es el registro";
    $scope.user = {};
    // $scope.user.name = "";
    // $scope.user.lasname = "";
    // $scope.user.email = "";
    // $scope.user.nick = "";
    // $scope.user.password = "";
    // $scope.user.profession = "";
    $scope.user.visible = false;

    $scope.registrar = function(user){
        
			// console.log(user);
            console.log($scope.user.visible);
			datos = $scope.datos
            $scope.user.visible = true;
			userServices.insertar(user).then(function(){
				$scope.response = userServices.response;
				console.log($scope.response)
                if($scope.response.response){
                    $scope.user.visible = false;
                    console.log($scope.user.visible);
                }
			});
    }

    
}])