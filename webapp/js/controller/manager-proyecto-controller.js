var app = angular.module('jscrumApp.managerProyectoCtrl',["ngStorage"]);

app.controller('managerProyectoCtrl', ['$scope','$filter','$window','$sessionStorage','equipoServices','$routeParams',function($scope,$filter,$window,$sessionStorage,equipoServices,$routeParams){
	$scope.saludo = "Vista Proyecto";
    // $scope.sprint = {}
    $scope.data = $sessionStorage.data;
    $scope.idProyecto = $routeParams.proyecto;
    $scope.verPila = false;
    $scope.verpila2 =true;
    $scope.verSprint = false;
    $scope.verSprint2 = true;
        // console.log($scope.idProyecto);  

    //fecha
    	
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
                // console.log($scope.proyecto)
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
                // console.log($scope.pilaInsertada);
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
    $scope.listarSprint($scope.idProyecto)
    console.log($scope.idProyecto)

}])