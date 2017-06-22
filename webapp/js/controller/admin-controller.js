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
        // console.log(user);
        $scope.v_age = false;
        $scope.v_des = false;    
        $scope.userMod = user;
        $scope.uM = $scope.userMod.rol ;
        $scope.data = {
            model: $scope.userMod.rol,
            availableOptions: [
            {name: 'Usuario'},
            {name: 'Administrador'},
            {name: 'Manager'}
            ]
        };
             if($scope.data.model == "Manager"){
                 $scope.v_age = true;  
                 $scope.v_des = false;   
             }
             if($scope.data.model == "Administrador"){
                 $scope.v_age = false   ;  
                 $scope.v_des = false;   
             }
             if($scope.data.model == "Usuario"){
                 $scope.v_age = false;  
                 $scope.v_des = true;   
             }
          $scope.$watch("data.model", function(newValue, oldValue) {
                if (newValue === oldValue) {
                return;
                }
                console.log(newValue);
            if(newValue == "Manager"){
                 $scope.v_age = true;  
                 $scope.v_des = false;   
             }
             if(newValue == "Administrador"){
                 $scope.v_age = false   ;  
                 $scope.v_des = false;   
             }
             if(newValue == "Usuario"){
                 $scope.v_age = false;  
                 $scope.v_des = true;   
             }
        
                // alert("El valor ha cambiado");
            });
        // console.log($scope.userMod.rol);
  
        $("#modificarModal").modal();
    }

    $scope.modificar = function(userMod){
        var rolMod = $scope.data.model;
        userMod.rol = rolMod;
        userServices.modificar(userMod).then(function(){
		    // $scope.response2 = userServices.response;
            // console.log($scope.response);
            $("#modificarModal").modal("hide");
             $scope.listar();
		});

        if(userMod.age){
            console.log("experiencia")
            console.log(userMod);               
            userServices.insertarManager(userMod).then(function(){
                    $scope.resMan = userServices.response;
                    console.log($scope.resMan);
                    // $("#modificarModal").modal("hide");
                    // $scope.listar();
                });
        }

        if(userMod.des){
                userServices.insertarUsuario(userMod).then(function(){
                    $scope.resUser = userServices.response;
                    console.log($scope.resUser);
                    // $("#modificarModal").modal("hide");
                    // $scope.listar();
                });
        }

        
    }

    $scope.removeItem = function(){
      $sessionStorage.$reset();
      console.log("Sesión finalizada");
    }

}])