var app = angular.module('jscrumApp.managerCtrl',["ngStorage"]);

app.controller('managerCtrl', ['$scope','$window','$sessionStorage','equipoServices',function($scope,$window,$sessionStorage,equipoServices){
	$scope.manager = "Manager";
    $scope.data = $sessionStorage.data;
    data = $scope.data;
    id = data.id
    $scope.responseProyecto = "";

    $scope.perfil = false;


    $scope.idManager = function(id){
        
			equipoServices.idManager(id).then(function(){
				$scope.idM = equipoServices.response;
                $scope.id_m = $scope.idM.message; 
               
                $scope.listar($scope.id_m);
			});
           
    }
    $scope.idManager(id)
    $scope.listar = function(id){
        
            // console.log(id);
			equipoServices.listar(id).then(function(){
				$scope.equipos = equipoServices.response.message;
                console.log($scope.equipos);
                // console.log($scope.response);
                // $scope.response.forEach(function(element) {
                    
                //     $scope.listarProyectos(element.id);

                // }, this);
			});

    }
    $scope.listarProyectos = function(equipo){
            
           $scope.equipoProyecto = equipo.nombre;
			equipoServices.listarProyectos(equipo.id).then(function(){
				$scope.responseProyecto = equipoServices.response.message;
                console.log($scope.responseProyecto)
			});
    }


    
//     $scope.juntarProyectos  = function (){
//            proyectos = $scope.proyectos;
//            equipos    = $scope.response;
           
//            console.log($scope.response);
//            console.log($scope.proyectos); 

//     }
//    setTimeout(function() {
//        $scope.juntarProyectos();
//    }, 1000);
    
    
    
    
    
    // $scope.mostrarModal = function(user){
    //     // console.log(user);
    //     $scope.userMod = user;
    //     $scope.data = {
    //         model: $scope.userMod.rol,
    //         availableOptions: [
    //         {name: 'Usuario'},
    //         {name: 'Admin'},
    //         {name: 'Manager'}
    //         ]
    //     };
    //     $("#modificarModal").modal();
    // }

    // $scope.modificar = function(userMod){
    //     var rolMod = $scope.data.model;
    //     userMod.rol = rolMod;
    //     userServices.modificar(userMod).then(function(){
	// 	    $scope.response = userServices.response;
    //         console.log($scope.response);
    //         $("#modificarModal").modal("hide");
    //          $scope.listar();
	// 	});

        
    // }

}])