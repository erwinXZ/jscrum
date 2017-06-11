var app = angular.module('jscrumApp.equipoServices',[])

app.factory('equipoServices', ['$http','$q','$rootScope', function($http,$q,$rootScope){

var self ={

				insertarProyecto : function(datos){
					var d = $q.defer();
					console.log(datos);
                    $http({
                      method: 'POST',
					  	url: 'http://192.168.1.14/Web/jscrum/api/public/proyecto/',
                        // url: 'http://localhost/gitgrad/APIPOLLO/public/observation/read/',
                        data:{
								_codigo:datos.codigo,
								_nombre:datos.name,
								_descripcion:datos.descripcion,
								_objetivo:datos.objetivo,
								_id_manager:datos.id_manager,
								_id_equipo:datos.id_equipo
						}
                    	})
                        .then(function successCallback(response) {
                                // ok
                                // self.cargado		= true;
    							// self.cargando		= false;
								self.response 	= response.data;
								// console.log("Service"+response);
								return d.resolve()	
                            }, function errorCallback(response) {
								
								self.response 	= response.data
								return d.resolve();
                        });
                       return d.promise;	 
	
				},
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

				listarM : function(id){
					var d = $q.defer();
                    
                    $http({
                      method: 'GET',
					  	url: 'http://192.168.1.14/Web/jscrum/api/public/equipo/listarEquiposM/'+id,
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

				listarProyectos : function(id){
					var d = $q.defer();
                    
                    $http({
                      method: 'GET',
					  	url: 'http://192.168.1.14/Web/jscrum/api/public/proyecto/listarProyectos/'+id,
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
	
				},

				idMiembro : function(id){
					var d = $q.defer();
                    
                    $http({
                      method: 'GET',
					  	url: 'http://192.168.1.14/Web/jscrum/api/public/miembro/idMiembro/'+id,
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