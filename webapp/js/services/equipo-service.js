var app = angular.module('jscrumApp.equipoServices',[])

app.factory('equipoServices', ['$http','$q','$rootScope', function($http,$q,$rootScope){

var self ={

				insertarProyecto : function(datos){
					var d = $q.defer();
					console.log(datos);
                    $http({
                      method: 'POST',
					  	url: 'http://192.168.1.7/Web/jscrum/api/public/proyecto/',
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
				insertarEquipo : function(datos){
					var d = $q.defer();
					console.log(datos);
                    $http({
                      method: 'POST',
					  	url: 'http://192.168.1.7/Web/jscrum/api/public/equipo/',
                        // url: 'http://localhost/gitgrad/APIPOLLO/public/observation/read/',
                        data:{
								_nombre:datos.nombre,
								_jornada:datos.jornada,
								_id_manager:datos.id_manager
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
				insertarPila : function(datos){
					var d = $q.defer();
					console.log(datos);
                    $http({
                      method: 'POST',
					  	url: 'http://192.168.1.7/Web/jscrum/api/public/pila/',
                        // url: 'http://localhost/gitgrad/APIPOLLO/public/observation/read/',
                        data:{
								_codigo:datos.codigo,
								_historia:datos.historia,
								_importancia:datos.importancia,
								_estimado_horas:datos.horas_estimadas,
								_id_proyecto:datos.id_proyecto
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
					  	url: 'http://192.168.1.7/Web/jscrum/api/public/equipo/listarEquipos/'+id,
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
					  	url: 'http://192.168.1.7/Web/jscrum/api/public/equipo/listarEquiposM/'+id,
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
					  	url: 'http://192.168.1.7/Web/jscrum/api/public/proyecto/listarProyectos/'+id,
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
				listarProyecto : function(id){
					var d = $q.defer();
                    
                    $http({
                      method: 'GET',
					  	url: 'http://192.168.1.7/Web/jscrum/api/public/proyecto/'+id,
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
				listarPila : function(id){
					var d = $q.defer();
                    
                    $http({
                      method: 'GET',
					  	url: 'http://192.168.1.7/Web/jscrum/api/public/pila/listarPila/'+id,
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
					  	url: 'http://192.168.1.7/Web/jscrum/api/public/manager/idManager/'+id,
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
					  	url: 'http://192.168.1.7/Web/jscrum/api/public/miembro/idMiembro/'+id,
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
				listarSprint : function(id){
					var d = $q.defer();
                    
                    $http({
                      method: 'GET',
					  	url: 'http://192.168.1.7/Web/jscrum/api/public/sprint/listarSprint/'+id,
                    	})
                        .then(function successCallback(response) {
								self.response 	= response.data;
								
								return d.resolve()	
                            }, function errorCallback(response) {
                            	return d.resolve()	
								self.response 	= response.data
                        });
                       return d.promise;	 
	
				}



	}


	return self;
}])