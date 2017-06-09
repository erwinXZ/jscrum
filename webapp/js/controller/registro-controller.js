var app = angular.module('jscrumApp.registroCtrl',[]);

app.controller('registroCtrl', ['$scope','userServices','$window' ,function($scope,userServices,$window){
	

    $scope.user = {};

    $scope.user.visible = false;
    $scope.user.respuesta = "";
    
    $scope.registrar = function(user){
        
			// console.log(user);
            console.log($scope.user.visible);
			datos = $scope.datos
            $scope.user.visible = true;
			userServices.insertar(user).then(function(){
				$scope.response = userServices.response;

                if($scope.response.message == "0"){
                    $scope.user.visible = false;
                    console.log($scope.user.visible);

                    $scope.user.respuesta = "El correo ya fue registrado, intente otro";
                    

                }
                if($scope.response.message == "1"){
                    $scope.user.visible = false;
                    console.log($scope.user.visible);
                    console.log("INsertado correctament");
                    $scope.user.respuesta = "Registro Relizado Correctamente";

                    setTimeout(function() {
                        $window.location.href = '#/form1.html';
                    }, 2000);
                }
                if($scope.response.message == "2"){
                    $scope.user.visible = false;
                    $scope.user.respuesta = "El usuario ya fue registrado, intente otro";
                    console.log($scope.user.visible);
                    console.log("Usuario incorrecto");
                }
			});
    }

    
}])