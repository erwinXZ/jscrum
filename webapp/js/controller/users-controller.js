var app = angular.module('jscrumApp.usersCtrl',["ngStorage"]);

app.controller('usersCtrl', ['$scope','usuarioServices','$window','$sessionStorage', 'equipoServices',function($scope,usuarioServices,$window,$sessionStorage, equipoServices){
	
    $scope.user = "usuario";
    $scope.data = $sessionStorage.data;
    data = $scope.data;
    id = data.id
    $scope.responseProyect = "";

    $scope.cargandoEquipos = true;
    $scope.verEquipos = false;
    $scope.noExisteEquipos = false;

    // $scope.cargandoProyectos = true;
    $scope.verProyectos = false;
    $scope.noExisteProyectos = false;

    $scope.perfil = false;
    $scope.nombreEquipo = false;

    $scope.cargandoMiembro = true;
    $scope.noExisteMiebros = false;
    $scope.verMiembros = false;
    $scope.miembroA = {};

    $scope.idMiembro = function(id){
        
			equipoServices.idMiembro(id).then(function(){
				$scope.idM = equipoServices.response;
                $scope.id_mi = $scope.idM.message; 
               
                $scope.listarM($scope.id_mi);
			});
           
    }
    $scope.idMiembro(id)

    $scope.listarM = function(id){
            $scope.cargandoEquipos = true;
            $scope.verEquipos = false;
            $scope.noExisteEquipos = false;
            console.log(id);
			equipoServices.listarM(id).then(function(){
                $scope.cargandoEquipos = false;
				$scope.equipos = equipoServices.response.message;
                if($scope.equipos[0].respuesta){
                    console.log("no tienes equipos")
                    $scope.noExisteEquipos = true;
                }else{
                    $scope.verEquipos = true;
                }
                
			});

    }
    
    // $scope.idManager = function(id){
        
	// 		equipoServices.idManager(id).then(function(){
	// 			$scope.idM = equipoServices.response;
    //             $scope.id_m = $scope.idM.message; 
               
    //             $scope.listar($scope.id_m);
	// 		});
           
    // }
    // $scope.idManager(id)
    
    $scope.listarProyectos = function(equipo){
            $scope.nombreEquipo = true;
           $scope.equipoProyecto = equipo;
           console.log(equipo);
            $scope.cargandoProyectos = true;
            $scope.verProyectos = false;
            $scope.noExisteProyectos = false;
        
			equipoServices.listarProyectos(equipo.id).then(function(){
				$scope.responseProyecto = equipoServices.response.message;
                // console.log(equipoServices.response)
                $scope.cargandoProyectos = false;
                if($scope.responseProyecto[0].respuesta){
                    console.log("no tienes equipos")
                    $scope.noExisteProyectos = true;
                }else{
                    $scope.verProyectos = true;
                }
			});
    }
    
    
    $scope.mostrarInsertarProyecto = function(equipo){
        console.log(equipo);
        proyecto = {
            id_equipo:equipo.id,
            id_manager:equipo.id_manager
        };

        $scope.proyect = proyecto;
        $("#modal-insertar-pro").modal();

    }


    //proyecto
    $scope.verProyecto =function(proyecto){
        console.log(proyecto)
        $window.location.href = '#/user/proyecto/'+proyecto.id;
    }

    $scope.removeItem = function(){
      $sessionStorage.$reset();
      console.log("Sesión finalizada");
    }

    $scope.mostrarMiembros = function(equipo){
        console.log(equipo.id);
        $scope.noExisteMiebros = false;
        $scope.verMiembros = false;
        $scope.cargandoMiembro = true ;
             equipoServices.listarME(equipo.id ).then(function(){
                 $scope.cargandoMiembro = false ;
                 $scope.miembrosE = equipoServices.response.message;
                 if($scope.miembrosE[0].respuesta){
                     $scope.noExisteMiebros = true;
                 }else{
                     $scope.verMiembros = true;
                 }
                // console.log($scope.miembrosE)
			});
            $scope.miembroA.id_equipo = equipo.id ;
        $("#modal-miembrou").modal();

    }


}])
