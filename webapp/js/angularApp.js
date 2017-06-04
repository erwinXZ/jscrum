var app = angular.module('jscrumApp',
	['ngRoute', 
	'jscrumApp.form1Ctrl',
	'jscrumApp.registroCtrl',
	'jscrumApp.adminCtrl',
	'jscrumApp.usersCtrl',
	'jscrumApp.userServices']
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
	.when('/users', {
		templateUrl: 'pages/users.html',
		controller: 'usersCtrl'
	})
	.otherwise({ 
		redirectTo: '/' 
	});
});

app.config(['$locationProvider', function($locationProvider) {
  $locationProvider.hashPrefix('');
}]);