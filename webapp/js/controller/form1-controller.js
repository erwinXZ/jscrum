var app = angular.module('losasApp.form1Ctrl',[]);

app.controller('form1Ctrl', ['$scope', function($scope){
	
	$scope.divi =  function(){
		var n1 = parseFloat($scope.num1);
		var n2 = parseFloat($scope.num2);
		var res = n1/n2;
		$scope.result = res;
	}

}])