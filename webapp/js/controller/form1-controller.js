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
					console.log("incorrecto");
					console.log(objeto.mesagge);
					$scope.user.respuesta = "Login Incorrecto";
				}else{
					$scope.user.visible = false;
					$scope.user.respuesta = "Login Correcto";
					console.log("correcto");
					console.log(objeto.mesagge);
					$sessionStorage.data = objeto.mesagge;
					 setTimeout(function() {
                        $window.location.href = '#/admin';
                    }, 2000);

					console.log(objeto.mesagge);
				}

                
			});
	}
}])