var app = angular.module('jscrumApp.form1Ctrl',["ngStorage"]);

app.controller('form1Ctrl', ['$scope','userServices','$window','$sessionStorage', function($scope,userServices,$window,$sessionStorage){
	$scope.user = {};
	$scope.login = "";
	$scope.password = "";
	$scope.user.visible = false;
    $scope.user.respuesta = "";
	
	$scope.logIn = function(user){

			datos = $scope.datos
            $scope.user.visible = true;
			
			userServices.logIn(user).then(function(){
				$scope.response = userServices.response;
				$scope.user.visible = true;
				objeto = $scope.response;
				if(objeto.mesagge.response == "0"){
					$scope.user.visible = false;
					//console.log("incorrecto");
					// console.log(objeto.mesagge);
					$scope.user.respuesta = "Login Incorrecto";
				}else{
					$scope.user.visible = false;
					$scope.user.respuesta = "Login Correcto";
					//console.log("correcto");
					// console.log(objeto.mesagge);
					$sessionStorage.data = objeto.mesagge;
					if(objeto.mesagge.rol == "Usuario")
					{
						console.log("Bienvenido Usuario");
						 setTimeout(function() {
 	                       $window.location.href = '#/user';
    	                }, 2000);

					}
					if(objeto.mesagge.rol == "Administrador")
					{
						console.log("Bienvenido Admin");
						setTimeout(function() {
 	                       $window.location.href = '#/admin';
    	                }, 2000);
					}
					if(objeto.mesagge.rol == "Manager")
					{
						console.log("Bienvenido manager");
						setTimeout(function() {
 	                       $window.location.href = '#/manager';
    	                }, 2000);
					}


					
					console.log(objeto.mesagge.rol);
				}

                
			});
	}
}])