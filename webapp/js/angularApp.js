var app = angular.module('jscrumApp',
	['ngRoute', 
	'jscrumApp.form1Ctrl',
	'jscrumApp.registroCtrl',
	'jscrumApp.adminCtrl',
	'jscrumApp.usersCtrl',
	'jscrumApp.managerCtrl',
	'jscrumApp.managerProyectoCtrl',
	'jscrumApp.userProyectoCtrl',
	'jscrumApp.userServices',
	'jscrumApp.equipoServices',
	'jscrumApp.usuarioServices']
	);

app.controller('mainCtrl', ['$scope','$http', function($scope,$http){

}]);

 app.config( function ($routeProvider) {

	$routeProvider
	.when('/', {
		templateUrl: 'pages/home.html'
	})
	.when('/form1', {
		templateUrl: 'pages/form1.html',
		controller: 'form1Ctrl'
	})
	.when('/registro', {
		templateUrl: 'pages/registro.html',
		controller: 'registroCtrl'
	})
	.when('/admin', {
		templateUrl: 'pages/admin/admin.html',
		controller: 'adminCtrl'
	})
	.when('/user', {
		templateUrl: 'pages/user/user.html',
		controller: 'usersCtrl'
	})
	.when('/manager', {
		templateUrl: 'pages/manager/manager.html',
		controller: 'managerCtrl'
	})
	.when('/manager/proyecto/:proyecto', {
		templateUrl: 'pages/manager/proyecto/proyecto.html',
		controller: 'managerProyectoCtrl'
	})
	.when('/user/proyecto/:proyecto', {
		templateUrl: 'pages/user/proyecto/proyecto.html',
		controller: 'userProyectoCtrl'
	})
	.otherwise({ 
		redirectTo: '/' 
	});
});

app.config(['$locationProvider', function($locationProvider) {
  $locationProvider.hashPrefix('');
}]);