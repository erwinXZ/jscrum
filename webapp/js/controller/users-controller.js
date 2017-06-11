var app = angular.module('jscrumApp.usersCtrl',["ngStorage"]);

app.controller('usersCtrl', ['$scope','usuarioServices','$window','$sessionStorage', 'equipoServices',function($scope,usuarioServices,$window,$sessionStorage, equipoServices){
	
    $scope.user = "usuario";
    $scope.data = $sessionStorage.data;
    data = $scope.data;
    // $scope.user.visible = false;
    // $scope.user.respuesta = "";
    id = data.id
    $scope.responseProyecto = "";

    $scope.perfil = false;

    $scope.idMiembro = function(id){
        
			equipoServices.idMiembro(id).then(function(){
				$scope.idM = equipoServices.response;
                $scope.id_m = $scope.idM.message; 
               
                $scope.listarM($scope.id_m);
			});
           
    }
    $scope.idMiembro(id)
    $scope.listarM = function(id){
        
            // console.log(id);
			equipoServices.listarM(id).then(function(){
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
           console.log(equipo.id_equipo);
			equipoServices.listarProyectos(equipo.id_equipo).then(function(){
				$scope.responseProyecto = equipoServices.response.message;
                console.log($scope.responseProyecto)
			});
    }


}])
