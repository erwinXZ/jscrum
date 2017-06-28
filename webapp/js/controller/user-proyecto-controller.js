var app = angular.module('jscrumApp.userProyectoCtrl',["ngStorage"]);

app.controller('userProyectoCtrl', ['$scope','$window','$sessionStorage','equipoServices','$routeParams',function($scope,$window,$sessionStorage,equipoServices,$routeParams){
	  $scope.data = $sessionStorage.data;
    $scope.idProyecto = $routeParams.proyecto;
    $scope.verPila = false;
    $scope.verpila2 =true;
    $scope.verSprint = false;
    $scope.verSprint2 = true;
    $scope.verProSpri = false;
    $scope.verProSpri2 = false;
    $scope.verProSpri3 = true;
    $scope.historiaInsert = false;
    $scope.btnTerminado = true;

    $scope.verBtnInsertar = false;
    
    	
         $scope.convertDate = function(date){
            var myDate = new Date(date);
                var month = lessThanTen(myDate.getMonth() + 1);
                var date = lessThanTen(myDate.getDate());
                var year = myDate.getFullYear();
                var format = year + '-' + month + '-' + date
                return format;
        }
        function lessThanTen(value) {
            return value < 10 ? '0' + value : value;
        }
    //finfecha
    
    $scope.listarProyecto = function(id){

			equipoServices.listarProyecto(id).then(function(){
				$scope.proyecto= equipoServices.response;
                console.log($scope.proyecto)
                if($scope.proyecto.estado == "Terminado"){
                    $scope.btnTerminado = false;
                }
                $sessionStorage.dataProyecto = $scope.proyecto;
			});
    }
    $scope.listarProyecto($scope.idProyecto);

    $scope.listarPila = function(id){

            equipoServices.listarPila(id).then(function(){
                

                $scope.pilas = equipoServices.response.message;
                // console.log($scope.pilas)
                if($scope.pilas[0].respuesta){
                    console.log("No existe Proyecto");
                }else{
                    $scope.verPila = true;
                    $scope.verpila2 = false;
                }

			});
    }

    $scope.listarPila($scope.idProyecto);

    $scope.mostrarInsertarPila = function(){
        $scope.pila = {
            id_proyecto : $scope.idProyecto
        }
         console.log("hola")
        $("#modal-insertar-pila").modal();
    }

    $scope.mostrarInsertarSprint = function(){
        // $scope.pila = {
        //     id_proyecto : $scope.idProyecto
        // }
         console.log("hola")
        $("#modal-insertar-sprint").modal();
    }

    $scope.insertarPila = function(pila){
        
			// console.log(pila);

			equipoServices.insertarPila(pila).then(function(){
				$scope.pilaInsertada = equipoServices.response;
                console.log($scope.pilaInsertada);
                if($scope.pilaInsertada.message == 0){
                    alert("Error al insertar, Codigo repetido")
                }
                 $("#modal-insertar-pila").modal("hide");
                //  console.log($scope.id_equipo);
                 $scope.listarPila($scope.idProyecto);
			});
    }    

    $scope.insertarSprint = function(sprint){

			//console.log(sprint);
           sprint.fechaEntrega = $scope.convertDate(sprint.fechaEntrega)
           sprint.idProyecto = $scope.idProyecto;
           console.log(sprint) 
			equipoServices.insertarSprint(sprint).then(function(){
				$scope.sprintInsertado = equipoServices.response;
                 console.log($scope.sprintInsertado);
                 $("#modal-insertar-sprint").modal("hide");
                
                 $scope.listarSprint($scope.idProyecto);
			});
    }  

    $scope.listarSprint = function(id){
        equipoServices.listarSprint(id).then(function(){
				$scope.sprints = equipoServices.response.message;
                // console.log($scope.sprints)
                if($scope.sprints[0].respuesta){
                    console.log("No existen Sprints")
                }else{
                    $scope.verSprint = true;
                    
                    $scope.verSprint2 = false;
                }
			});
    }

    //listarProyectoSprint

    $scope.listarProyectoSprint = function(datos){
        
        datos.idProyecto = $scope.idProyecto;
        // console.log(datos);
        $scope.sprintId = datos.id;
        // console.log($scope.sprintId)
        console.log(datos)
        $scope.verBtnInsertar = false;
			equipoServices.listarProyectoSprint(datos).then(function(){
				$scope.listaProyectoSprint = equipoServices.response.message;
                // console.log($scope.listaProyectoSprint.response.message)
                if($scope.listaProyectoSprint[0].respuesta){
                    // console.log("No existe Proyecto");
                    // console.log($scope.listaProyectoSprint);
                    $scope.verProSpri = false;
                    $scope.verProSpri2 = true;
                    $scope.verProSpri3 = false;
                    $scope.verBtnInsertar = false;
                    
                }else{
                    // console.log($scope.listaProyectoSprint);
                    $scope.verProSpri = true;
                    $scope.verProSpri2 = false;
                    $scope.verProSpri3 = false;
                    $scope.verBtnInsertar = true;
                }
			});
    }
    $scope.mostrarinsertarProyectoSprint = function(){

        $("#modal-insertar-proyecto-sprint").modal();
    }

    $scope.insertarProyectoSprint = function(datos){
        datos.idProyecto = $scope.idProyecto;
        datos.idSprint = $scope.sprintId;
        datos.id = $scope.sprintId;
        
			equipoServices.insertarProyectoSprint(datos).then(function(){
				$scope.insertarPS = equipoServices.response;
                console.log($scope.insertarPS)
                if($scope.insertarPS.message == 0){
                    $scope.historiaInsert = true;
                }else{
                    $scope.historiaInsert = false;
                    $scope.listarProyectoSprint(datos);   
                }
                $("#modal-insertar-proyecto-sprint").modal("hide");
               
			});
    }

    $scope.listarSprint($scope.idProyecto)
    // console.log($scope.idProyecto);

    $scope.verAvance = function(sprint){
        console.log(sprint);
       $sessionStorage.sprint = sprint;
        $window.location.href = '#/user/proyecto/sprint';
    }

    // $scope.verAvance1 = function(sprint){
    //     console.log(sprint);
    //    $sessionStorage.sprint = sprint;
    //     $window.location.href = '#/user/proyecto/sprint';
    // }

    $scope.removeItem = function(){
      $sessionStorage.$reset();
      console.log("Sesión finalizada");
    }

    $scope.mostrarTerminar = function (proyecto){
        console.log(proyecto);
        $scope.proyectoT = proyecto;
        $("#modal-terminar-proyecto").modal();

    }

    $scope.terminarProyecto = function(datos){
        console.log(datos.id)
        
			equipoServices.terminarProyecto(datos.id).then(function(){
				$scope.proTerminado = equipoServices.response;
                console.log($scope.proTerminado)
                 $scope.listarProyecto($scope.idProyecto);
                 $("#modal-terminar-proyecto").modal("hide");
			});
    }

}])