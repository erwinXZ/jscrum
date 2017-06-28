var app = angular.module('jscrumApp.sprintServices',[])

app.factory('sprintServices', ['$http','$q','$rootScope', function($http,$q,$rootScope){

var self ={
				listarSeguimiento : function(id){
					var d = $q.defer();
                    
                    $http({
                      method: 'GET',
					  	url: 'http://192.168.1.6/Web/jscrum/api/public/sprint/listarSeguimiento/'+id,
                    	})
                        .then(function successCallback(response) {
								self.response 	= response.data;
								
								return d.resolve()	
                            }, function errorCallback(response) {
                            	return d.resolve()	
								self.response 	= response.data
                        });
                       return d.promise;	 
	
				},

				listarSprintBacklog : function(id){
					var d = $q.defer();
                    
                    $http({
                      method: 'GET',
					  	url: 'http://192.168.1.6/Web/jscrum/api/public/tarea/listarTareas/'+id,
                    	})
                        .then(function successCallback(response) {
                              
								self.response 	= response.data;
								
								return d.resolve()	
                            }, function errorCallback(response) {
                        
                            	return d.resolve()	
                              
								self.response 	= response.data
                        });
                       return d.promise;	 
	
				},
				listarDias : function(id){
					var d = $q.defer();
                    
                    $http({
                      method: 'GET',
					  	url: 'http://192.168.1.6/Web/jscrum/api/public/sprint/listarDias/'+id,
                    	})
                        .then(function successCallback(response) {
                              
								self.response 	= response.data;
								
								return d.resolve()	
                            }, function errorCallback(response) {
                        
                            	return d.resolve()	
                              
								self.response 	= response.data
                        });
                       return d.promise;	 
	
				},

				listarEquipo : function(id){
					var d = $q.defer();
                    
                    $http({
                      method: 'GET',
					  	url: 'http://192.168.1.6/Web/jscrum/api/public/sprint/listarMiembrosE/'+id,
                    	})
                        .then(function successCallback(response) {
                              
								self.response 	= response.data;
								
								return d.resolve()	
                            }, function errorCallback(response) {
                        
                            	return d.resolve()	
                              
								self.response 	= response.data
                        });
                       return d.promise;	 
				},
				listarEsfuerzo : function(id){
					var d = $q.defer();
                    
                    $http({
                      method: 'GET',
					  	url: 'http://192.168.1.6/Web/jscrum/api/public/esfuerzo/listarEsfuerzo/'+id,
                    	})
                        .then(function successCallback(response) {
                              
								self.response 	= response.data;
								
								return d.resolve()	
                            }, function errorCallback(response) {
                        
                            	return d.resolve()	
                              
								self.response 	= response.data
                        });
                       return d.promise;	 
				},
				insertarSprintBacklog : function(datos){
					var d = $q.defer();
					console.log(datos);
                    $http({
                      method: 'POST',
					  	url: 'http://192.168.1.6/Web/jscrum/api/public/tarea/',
                        data:{
								_codigo:datos.codigo,
								_indice:datos.indice,
								_descripcion:datos.descripcion,
								_tipo:datos.tipo,
								_total_horas:datos.total_horas,
								_id_sprint:datos.id_sprint,
								_id_miembro:datos.id_miembro

						}
                    	})
                        .then(function successCallback(response) {

								self.response 	= response.data;
								return d.resolve()	
                            }, function errorCallback(response) {
								
								self.response 	= response.data
								return d.resolve();
                        });
                       return d.promise;	 
				},
				insertarEsfuerzo : function(datos){
					var d = $q.defer();
					console.log(datos);
                    $http({
                      method: 'POST',
					  	url: 'http://192.168.1.6/Web/jscrum/api/public/esfuerzo/',
                        data:{
								_cantidad:datos.cantidad,
								_id_tarea:datos.id_tarea,
								_id_sprint:datos.id_sprint

						}
                    	})
                        .then(function successCallback(response) {

								self.response 	= response.data;
								return d.resolve()	
                            }, function errorCallback(response) {
								
								self.response 	= response.data
								return d.resolve();
                        });
                       return d.promise;	 
				}



	}


	return self;
}])