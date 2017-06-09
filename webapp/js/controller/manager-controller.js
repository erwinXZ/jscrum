var app = angular.module('jscrumApp.managerCtrl',["ngStorage"]);

app.controller('managerCtrl', ['$scope','$window','$sessionStorage','equipoServices',function($scope,$window,$sessionStorage,equipoServices){
	$scope.manager = "Manager";
    $scope.data = $sessionStorage.data;
    data = $scope.data;
    id = data.id
    // $scope.user.visible = false;
    // $scope.user.respuesta = "";
    $scope.listar = function(){
        
			// console.log(id);
            // console.log($scope.user.visible);
            // $scope.user.visible = true;
			equipoServices.listar(id).then(function(){
				$scope.response = equipoServices.response;
                console.log($scope.response);
			});
    }
    $scope.listar();
    
    
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