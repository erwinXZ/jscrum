var app = angular.module('jscrumApp.managerCtrl',["ngStorage"]);

app.controller('managerCtrl', ['$scope','$window','$sessionStorage','equipoServices',function($scope,$window,$sessionStorage,equipoServices){
	$scope.manager = "Manager";
    $scope.data = $sessionStorage.data;
    data = $scope.data;
    id = data.id
    $scope.responseProyecto = "";

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
                console.log($scope.equipos);
                // console.log($scope.response);
                // $scope.response.forEach(function(element) {
                    
                //     $scope.listarProyectos(element.id);

                // }, this);
			});

    }
    $scope.listarProyectos = function(equipo){
            $scope.nombreEquipo = true;
           $scope.equipoProyecto = equipo;
			equipoServices.listarProyectos(equipo.id).then(function(){
				$scope.responseProyecto = equipoServices.response.message;
                console.log($scope.responseProyecto)
			});
    }
    
    
    $scope.mostrarInsertarProyecto = function(){

        $("#modal-insertar-pro").modal();
    }

}])