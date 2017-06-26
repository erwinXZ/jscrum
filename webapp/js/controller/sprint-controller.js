var app = angular.module('jscrumApp.sprintCtrl',["ngStorage"]);

app.controller('sprintCtrl', ['$scope','sprintServices','$window','$sessionStorage' ,function($scope,sprintServices,$window,$sessionStorage){

    $scope.sprint = "Sprint";
    $scope.dataSprint = $sessionStorage.sprint;

    console.log($scope.dataSprint.total_horas_persona)

    Highcharts.setOptions({
        chart: {
            backgroundColor: {
                linearGradient: [0, 0, 500, 500],
                stops: [
                    [0, 'rgb(255, 255, 255)'],
                    [1, 'rgb(240, 240, 255)']
                    ]
            },
            borderWidth: 2,
            plotBackgroundColor: 'rgba(255, 255, 255, .9)',
            plotShadow: true,
            plotBorderWidth: 1
        }
    });

    var chart2 = new Highcharts.Chart({
        chart: {
            renderTo: 'container',
            type: 'area'
        },

        xAxis: {
            type: 'datetime',
        },

        series: [{
            data: [parseInt($scope.dataSprint.total_horas_persona)],
            pointStart: Date.UTC(2017, parseInt($scope.dataSprint.fecha_inicio.substring(5,7)), parseInt($scope.dataSprint.fecha_inicio.substring(8,10))),
            pointInterval: 3600 * 1000 * 24

        },{
            type: 'line',
            name: 'linea',
            data: [parseInt($scope.dataSprint.total_horas_persona)],
            pointStart: Date.UTC(2017, parseInt($scope.dataSprint.fecha_inicio.substring(5,7)), parseInt($scope.dataSprint.fecha_inicio.substring(8,10))),
            pointInterval: 3600 * 1000 * 24
    }]

    });
    
    var chart1 = new Highcharts.Chart({
        chart: {
            renderTo: 'container2',
        },

        xAxis: {
            type: 'datetime'
        },

        series: [{
            data: [60, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1, 95.6, 54.4],
            pointStart: Date.UTC(2017, $scope.dataSprint.fecha_inicio.substring(5,6), $scope.dataSprint.fecha_entrega.substring(8,9)),
            pointInterval: 3600 * 1000 *24
        }]
    });

    
}])