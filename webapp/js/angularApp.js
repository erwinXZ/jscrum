var app = angular.module('jscrumApp',['ngRoute', 'jscrumApp.form1Ctrl']);

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
	.otherwise({ 
		redirectTo: '/' 
	});
});

app.config(['$locationProvider', function($locationProvider) {
  $locationProvider.hashPrefix('');
}]);