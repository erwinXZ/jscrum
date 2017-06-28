var app = angular.module('jscrumApp.managerCtrl',["ngStorage"]);

app.controller('managerCtrl', ['$scope','$window','$sessionStorage','equipoServices',function($scope,$window,$sessionStorage,equipoServices){
	$scope.manager = "Manager";
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

    $scope.miembroA = {};
    $scope.cargandoMiembro = true;
    $scope.noExisteMiebros = false;
    $scope.verMiembros = false;

    $scope.cargadoInsertMiembro = false;
    $scope.idManager = function(id){
        
			equipoServices.idManager(id).then(function(){
				$scope.idM = equipoServices.response;
                $scope.id_m = $scope.idM.message; 
               
                $scope.listar($scope.id_m);
			});
           
    }
    $scope.idManager(id)
    $scope.listar = function(id){
            $scope.cargandoEquipos = true;
            $scope.verEquipos = false;
            $scope.noExisteEquipos = false;
            console.log(id);
			equipoServices.listar(id).then(function(){
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


    $scope.insertarProyecto = function(proyecto){
        
			console.log(proyecto);
            // console.log($scope.user.visible);
			// datos = $scope.datos
            // $scope.user.visible = true;
            $scope.id_equipo ={
                id:proyecto.id_equipo
            } 
			equipoServices.insertarProyecto(proyecto).then(function(){
				$scope.responseP = equipoServices.response;
                console.log($scope.responseP);
                 $("#modal-insertar-pro").modal("hide");
                 console.log($scope.id_equipo);
                $scope.listarProyectos($scope.id_equipo);
                // if($scope.response.message == "0"){
                //     $scope.user.visible = false;
                //     console.log($scope.user.visible);

                //     $scope.user.respuesta = "El correo ya fue registrado, intente otro";
                    

                // }
                // if($scope.response.message == "1"){
                //     $scope.user.visible = false;
                //     console.log($scope.user.visible);
                //     console.log("INsertado correctament");
                //     $scope.user.respuesta = "Registro Relizado Correctamente";
                //     setTimeout(function() {
                //         $window.location.href = '#/form1.html';
                //     }, 2000);
                // }
                // if($scope.response.message == "2"){
                //     $scope.user.visible = false;
                //     $scope.user.respuesta = "El usuario ya fue registrado, intente otro";
                //     console.log($scope.user.visible);
                //     console.log("Usuario incorrecto");
                // }
			});
    }

    $scope.mostrarInsertarEquipo = function(){
        console.log($scope.id_m );
        $scope.equipo = {
            id_manager:$scope.id_m 
        }

        $("#modal-insertar-equipo").modal();

    }

 $scope.insertarEquipo = function(equipo){
        
			console.log(equipo);

			equipoServices.insertarEquipo(equipo).then(function(){
				$scope.responseE = equipoServices.response;
                console.log($scope.responseE);
                 $("#modal-insertar-equipo").modal("hide");
                 console.log($scope.id_equipo);
                $scope.listar($scope.id_m);
			});
    }

    //proyecto
    $scope.verProyecto =function(proyecto){
        console.log(proyecto)
        $window.location.href = '#/manager/proyecto/'+proyecto.id;
    }

    $scope.removeItem = function(){
      $sessionStorage.$reset();
      console.log("Sesión finalizada");
    }

    $scope.mostrarMiembros = function(equipo){
        console.log(equipo.id );
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
        $("#modal-miembro").modal();

    }


    $scope.asignarMiembroE = function(miembroA){
			$scope.cargadoInsertMiembro = true;
                equipoServices.asignarEquipoM(miembroA).then(function(){
				$scope.responseM = equipoServices.response;
                console.log($scope.responseM);
                $scope.cargadoInsertMiembro = false;
                if($scope.responseM.message == 0){
                    alert("No Existe Usuario")
                }
                if($scope.responseM.message == 2){
                    alert("Usuario ya añadido al equipo")
                    console.log(miembroA)
                }
                if($scope.responseM.message == 1){
                    alert("Usuario Correctamente Insertado")
                    equipoN = {}
                    equipoN.id = miembroA.id_equipo
                    $scope.mostrarMiembros(equipoN);
                }
                //  $("#modal-miembro").modal("hide");
                //  console.log($scope.id_equipo);
                // $scope.listar($scope.id_m);
			});    
            

    }

   
}])