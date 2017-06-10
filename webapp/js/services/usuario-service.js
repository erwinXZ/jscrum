var app = angular.module('jscrumApp.usuarioServices',[])

app.factory('usuarioServices', ['$http','$q','$rootScope', function($http,$q,$rootScope){

var self ={

				listar : function(id){
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

				// listar : function(){
				// 	var doc = 2;
				// 	var d = $q.defer()
                //     $http({
                //       method: 'POST',
				// 	  	url: 'http://192.168.1.11/Web/gitgrad/api/public/observation/read/',
                //         // url: 'http://localhost/gitgrad/APIPOLLO/public/observation/read/',
                //         data:{'id':doc}
                //     	})
                //         .then(function successCallback(response) {
                //                 // ok
                //                 self.cargado		= true;
    			// 				self.cargando		= false;
				// 				self.comentarios 	= response.data;
								
				// 				return d.resolve()	
                //             }, function errorCallback(response) {
                //             // ko
                //             	return d.resolve()	
                //                 self.cargado		= true;
    			// 				self.cargando		= false;
				// 				self.comentarios 	= response.data
                //         });
                //        return d.promise;	 
	
				// },					
				// eliminar : function(id){
				// 	var d = $q.defer()
                //     $http({
                //       method: 'DELETE',
				// 	  	url: 'http://192.168.1.11/Web/gitgrad/api/public/observation/'+id,
                //         // url: 'http://localhost/gitgrad/APIPOLLO/public/observation/read/',
                //     	})
                //         .then(function successCallback(response) {
                //                 // ok
				// 				self.response 	= response.data;
								
				// 				self.listar()
				// 				return d.resolve()	
                //             }, function errorCallback(response) {
                //             // ko
				// 				self.response 	= response.data;
                //             	return d.resolve()	
                //         });
                //        return d.promise;
				// 	}	

	}


	return self;
}])