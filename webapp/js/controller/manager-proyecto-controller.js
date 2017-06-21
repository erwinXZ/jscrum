var app = angular.module('jscrumApp.managerProyectoCtrl',["ngStorage"]);

app.controller('managerProyectoCtrl', ['$scope','$window','$sessionStorage','equipoServices','$routeParams',function($scope,$window,$sessionStorage,equipoServices,$routeParams){
	$scope.saludo = "Vista Proyecto";
    $scope.data = $sessionStorage.data;
    $scope.idProyecto = $routeParams.proyecto;
    $scope.verPila = false;
    $scope.verpila2 =true;
    $scope.verSprint = false;
    $scope.verSprint2 = true;
    console.log($scope.idProyecto);  
    
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

    $scope.insertarPila = function(pila){
        
			console.log(pila);

			equipoServices.insertarPila(pila).then(function(){
				$scope.pilaInsertada = equipoServices.response;
                // console.log($scope.pilaInsertada);
                 $("#modal-insertar-pila").modal("hide");
                //  console.log($scope.id_equipo);
                 $scope.listarPila($scope.idProyecto);
			});
    }    

    $scope.listarSprint = function(id){
        equipoServices.listarSprint(id).then(function(){
				$scope.sprints = equipoServices.response.message;
                console.log($scope.sprints)
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