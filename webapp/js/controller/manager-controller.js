var app = angular.module('jscrumApp.managerCtrl',["ngStorage"]);

app.controller('managerCtrl', ['$scope','$window','$sessionStorage','equipoServices',function($scope,$window,$sessionStorage,equipoServices){
	$scope.manager = "Manager";
    $scope.data = $sessionStorage.data;
    data = $scope.data;
    id = data.id
    $scope.responseProyect = "";

    $scope.perfil = false;
    $scope.nombreEquipo = false;

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
			});

    }
    $scope.listarProyectos = function(equipo){
            $scope.nombreEquipo = true;
           $scope.equipoProyecto = equipo;
           console.log(equipo);
			equipoServices.listarProyectos(equipo.id).then(function(){
				$scope.responseProyecto = equipoServices.response.message;
                console.log(equipoServices.response)
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
        // proyecto = {
        //     id_equipo:equipo.id,
        //     id_manager:equipo.id_manager
        // };

        // $scope.proyect = proyecto;
        $("#modal-insertar-equipo").modal();

    }

 $scope.insertarEquipo = function(equipo){
        
			console.log(equipo);
            // console.log($scope.user.visible);
			// datos = $scope.datos
            // $scope.user.visible = true;
            // $scope.id_equipo ={
            //     id:proyecto.id_equipo
            // } 
			equipoServices.insertarEquipo(equipo).then(function(){
				$scope.responseE = equipoServices.response;
                console.log($scope.responseE);
                 $("#modal-insertar-equipo").modal("hide");
                 console.log($scope.id_equipo);
                $scope.listar($scope.id_m);
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
        $scope.equipo = {
            id_manager:$scope.id_m 
        }
        proyecto = {
            id_equipo:equipo.id,
            id_manager:equipo.id_manager
        };

        $scope.proyect = proyecto;
        $("#modal-miembro").modal();

    }

    // $scope.listarMiembrosEquipo = function(id){
    //         equipoServices.listarMiembrosEquipo(id).then(function(){

    //             $scope.miembros = equipoServices.response.message;
    //             // console.log($scope.horas)
    //             if($scope.miembros[0].respuesta){
    //                 console.log("No existen Miembros");
    //             }else{
    //                 console.log($scope.miembros)
    //             }
	// 		});
            
    // }

    $scope.asignarEquipoM = function(equipo){
			console.log(equipo);
            $scope.id_equipo ={
                id:equipo.id_equipo
            } 
			equipoServices.asignarEquipoM(equipo).then(function(){
				$scope.responseM = equipoServices.response;
                console.log($scope.responseM);
                 $("#modal-miembro").modal("hide");
                 console.log($scope.id_equipo);
                $scope.listar($scope.id_m);
			});
    }

   
}])