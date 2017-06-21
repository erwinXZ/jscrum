var app = angular.module('jscrumApp.userProyectoCtrl',["ngStorage"]);

app.controller('userProyectoCtrl', ['$scope','$window','$sessionStorage','equipoServices','$routeParams',function($scope,$window,$sessionStorage,equipoServices,$routeParams){
	$scope.saludo = "Vista Proyecto";
    $scope.data = $sessionStorage.data;
    $scope.idProyecto = $routeParams.proyecto;
    $scope.verPila = false;
    $scope.verpila2 =true;

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
                console.log($scope.pilas)
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


}])