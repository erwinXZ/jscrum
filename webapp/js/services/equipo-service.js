var app = angular.module('jscrumApp.equipoServices',[])

app.factory('equipoServices', ['$http','$q','$rootScope', function($http,$q,$rootScope){

var self ={

				// insertar : function(datos){
				// 	var d = $q.defer();
				// 	console.log(datos);
                //     $http({
                //       method: 'POST',
				// 	  	url: 'http://192.168.1.14/Web/jscrum/api/public/usuario/',
                //         // url: 'http://localhost/gitgrad/APIPOLLO/public/observation/read/',
                //         data:{
				// 				_nombre:datos.name,
				// 				_apellidos:datos.lastname,
				// 				_email:datos.email,
				// 				_login:datos.nick,
				// 				_password:datos.password,
				// 				_profesion:datos.profession
				// 		}
                //     	})
                //         .then(function successCallback(response) {
                //                 // ok
                //                 // self.cargado		= true;
    			// 				// self.cargando		= false;
				// 				self.response 	= response.data;
				// 				// console.log("Service"+response);
				// 				return d.resolve()	
                //             }, function errorCallback(response) {
								
				// 				self.response 	= response.data
				// 				return d.resolve();
                //         });
                //        return d.promise;	 
	
				// },
				listar : function(id){
					var d = $q.defer();
                    
                    $http({
                      method: 'GET',
					  	url: 'http://192.168.1.14/Web/jscrum/api/public/equipo/listarEquipos/'+id,
                    	})
                        .then(function successCallback(response) {
                                // ok
                                // self.cargado		= true;
    							// self.cargando		= false;
								self.response 	= response.data;
								
								return d.resolve()	
                            }, function errorCallback(response) {
                            // ko
                            	return d.resolve()	
                                // self.cargado		= true;
    							// self.cargando		= false;
								self.response 	= response.data
                        });
                       return d.promise;	 
	
				},
				idManager : function(id){
					var d = $q.defer();
                    
                    $http({
                      method: 'GET',
					  	url: 'http://192.168.1.14/Web/jscrum/api/public/manager/idManager/'+id,
                    	})
                        .then(function successCallback(response) {
                                // ok
                                // self.cargado		= true;
    							// self.cargando		= false;
								self.response 	= response.data;
								
								return d.resolve()	
                            }, function errorCallback(response) {
                            // ko
                            	return d.resolve()	
                                // self.cargado		= true;
    							// self.cargando		= false;
								self.response 	= response.data
                        });
                       return d.promise;	 
	
				}
				// modificar : function(user){
				// 	var d = $q.defer();
				
                //     $http({
                //       method: 'POST',
				// 	  	url: 'http://192.168.1.14/Web/jscrum/api/public/usuario/rol/',
				// 		  data:{
				// 				_id:user.id,
				// 				_rol:user.rol
				// 		}
                //     	})
                //         .then(function successCallback(response) {
                //                 // ok
                //                 // self.cargado		= true;
    			// 				// self.cargando		= false;
				// 				self.response 	= response.data;
								
				// 				return d.resolve()	
                //             }, function errorCallback(response) {
                //             // ko
                //             	return d.resolve()	
                //                 // self.cargado		= true;
    			// 				// self.cargando		= false;
				// 				self.response 	= response.data
                //         });
                //        return d.promise;	 
				// }	   

	}


	return self;
}])