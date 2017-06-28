var app = angular.module('jscrumApp.sprintCtrl',["ngStorage"]);

app.controller('sprintCtrl', ['$scope','sprintServices','$window','$sessionStorage' ,function($scope,sprintServices,$window,$sessionStorage){

    $scope.sprint = "Sprint";
    $scope.data = $sessionStorage.data;
    $scope.dataSprint = $sessionStorage.sprint;
    $sessionStorage.dataProyecto;
    $scope.horas_a =[];
    $scope.tareas_a =[];
    $scope.proyectoId = $sessionStorage.dataProyecto.id;    
    $scope.vistaSprintBacklog = false;
    $scope.vistaSprintCargando = true;
    $scope.vistaSprintNoExisten = false;
    $scope.vistaListaEsfuerzo = false;
    $scope.verTareas = false;
    $scope.cargandoTareas =  true;

    $scope.diaEsfuerzo = {};
    $scope.diaEsfuerzo.id_sprint =  $scope.dataSprint.id;

    console.log(parseInt($scope.dataSprint.fecha_inicio.substring(5,7)))
   
    $scope.listarSeguimiento = function(id){

            sprintServices.listarSeguimiento(id).then(function(){

                $scope.horas = sprintServices.response.message;
                // console.log($scope.horas)
                if($scope.horas[0].respuesta){
                    console.log("No existe el sprint");
                }else{
                    var horas = $scope.horas ;
                     $scope.horas_a = new Array();
                     $scope.tareas_a = new Array();
                    angular.forEach(horas, function(horas, key) {
                        // this.push(key + ': ' + value);
                        // console.log(horas.horas_persona_pendientes);
                        $scope.horas_a.push(parseInt(horas.horas_persona_pendientes));
                        $scope.tareas_a.push(parseInt(horas.tareas_persona_pendientes));
                    });
                    console.log($scope.horas_a)
                }
                // return $scope.horas_a;
			});
            
    }

   $scope.listarSeguimiento($scope.dataSprint.id);

  
        // console.log($scope.horas_a)
 
   
    setTimeout(function() {
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
    // console.log(horas_a);
    var chart2 = new Highcharts.Chart({
        chart: {
            renderTo: 'container',
            type: 'area'
        },
        
        title: {
        text: 'Gráfico Burn-Down'
        },

        xAxis: {
            type: 'datetime',
            title: {
                text: 'Fecha'
            },
            // categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
        },

        yAxis: {
            title: {
                text: 'Horas de trabajo pendientes'
            },
        },
        
        series: [{
            name: 'Esfuerzo',
            data: $scope.horas_a,
            pointStart: Date.UTC(parseInt($scope.dataSprint.fecha_inicio.substring(0,5)), parseInt($scope.dataSprint.fecha_inicio.substring(5,7)), parseInt($scope.dataSprint.fecha_inicio.substring(8,10))),
            pointInterval: 3600 * 1000 * 24

        },{
            type: 'line',
            name: 'Linea esfuerzo',
            data: [{
                        x: Date.UTC (parseInt($scope.dataSprint.fecha_inicio.substring(0,5)), parseInt($scope.dataSprint.fecha_inicio.substring(5,7)),parseInt($scope.dataSprint.fecha_inicio.substring(8,10))),
                        y: parseInt($scope.dataSprint.total_horas_persona),
                        name: "Point1",
                        color: "#00FF00"
                    }, {
                        x: Date.UTC (parseInt($scope.dataSprint.fecha_entrega.substring(0,5)), parseInt($scope.dataSprint.fecha_entrega.substring(5,7)),parseInt($scope.dataSprint.fecha_entrega.substring(8,10))),
                        y: 0,
                        name: "Point2",
                        color: "#FF00FF"
                    }],
            
            pointStart: Date.UTC(parseInt($scope.dataSprint.fecha_inicio.substring(0,5)), parseInt($scope.dataSprint.fecha_inicio.substring(5,7)), parseInt($scope.dataSprint.fecha_inicio.substring(8,10))),
            pointInterval: 3600 * 1000 * 24
    }]

    });
    
    var chart1 = new Highcharts.Chart({
        chart: {
            renderTo: 'container2',
        },

        title: {
        text: 'Gráfico Tareas'
        },

        xAxis: {
            type: 'datetime',
            title: {
                text: 'Fecha'
            }
        },

        yAxis: {
            title: {
                text: 'Tareas pendientes'
            }
        },

        series: [{
            name: 'Tareas',
            data: $scope.tareas_a,
            pointStart: Date.UTC(parseInt($scope.dataSprint.fecha_inicio.substring(0,5)), parseInt($scope.dataSprint.fecha_inicio.substring(5,7)), parseInt($scope.dataSprint.fecha_inicio.substring(8,10))),
            pointInterval: 3600 * 1000 * 24

        },{
            type: 'line',
            name: 'Linea tareas',
            data: [{
                        x: Date.UTC (parseInt($scope.dataSprint.fecha_inicio.substring(0,5)), parseInt($scope.dataSprint.fecha_inicio.substring(5,7)),parseInt($scope.dataSprint.fecha_inicio.substring(8,10))),
                        y: parseInt($scope.dataSprint.total_tareas),
                        name: "Point1",
                        color: "#00FF00"
                    }, {
                        x: Date.UTC (parseInt($scope.dataSprint.fecha_entrega.substring(0,5)), parseInt($scope.dataSprint.fecha_entrega.substring(5,7)),parseInt($scope.dataSprint.fecha_entrega.substring(8,10))),
                        y: 0,
                        name: "Point2",
                        color: "#FF00FF"
                    }],
            
            pointStart: Date.UTC(parseInt($scope.dataSprint.fecha_inicio.substring(0,5)), parseInt($scope.dataSprint.fecha_inicio.substring(5,7)), parseInt($scope.dataSprint.fecha_inicio.substring(8,10))),
            pointInterval: 3600 * 1000 * 24
        }]
    });

      }, 2000);

      $scope.listarSprintBacklog = function(id){
            sprintServices.listarSprintBacklog(id).then(function(){
              $scope.vistaSprintCargando = false;
				$scope.listaSprintBacklog = sprintServices.response.message;
                // console.log($scope.listaSprintBacklog);
                if($scope.listaSprintBacklog[0].respuesta){
                    $scope.vistaSprintNoExisten = true;
                }else{
                    $scope.vistaSprintBacklog = true;
                     
                }
			});
    }

    $scope.listarEsfuerzo = function(id){
        sprintServices.listarEsfuerzo(id).then(function(){
				$scope.listaEsfuerzo = sprintServices.response.message;
                console.log($scope.listaSprintBacklog)
                console.log($scope.listaEsfuerzo);
                var tareas = [];
                var auxTarea =[]
                var auxTarea = $scope.listaSprintBacklog;
                var auxEsfuerzo = $scope.listaEsfuerzo;

                auxTarea.forEach(function(auxTarea) {
                   
                    auxEsfuerzo.forEach(function(auxEsfuerzo) {
                    
                        if(auxTarea.id == auxEsfuerzo.id_tarea ){
                            

                            auxTarea.cant=auxEsfuerzo.cantidades.split(",").sort(function(a,b){ return b - a});

                            console.log(auxTarea.cant[0])
                        }
                    }, this);
                
                }, this);
                
                console.log(auxTarea)
                $scope.tareas = auxTarea;
                $scope.verTareas  = true;
                $scope.cargandoTareas =  false;
		});
    }


    

   

    $scope.listarDias = function(id){
            sprintServices.listarDias(id).then(function(){
				$scope.listaDias = sprintServices.response.message;
                // console.log($scope.listaDias);
			});
    }
    $scope.listarDias($scope.dataSprint.id) 
    $scope.listarSprintBacklog($scope.dataSprint.id);
    setTimeout(function() {
        $scope.listarEsfuerzo($scope.dataSprint.id);    
    }, 2000);
   
    $scope.mostrarInsertarSprintBacklog = function(){
        $scope.sprintBacklog = {
            id_sprint:$scope.dataSprint.id
        };
        console.log($scope.sprintBacklog);  
        
         $("#modal-insertar-sprint-backlog").modal();

    }
    $scope.listarEquipo = function(id){
        sprintServices.listarEquipo(id).then(function(){
              $scope.vistaSprintCargando = false;
				$scope.listaEquipo = sprintServices.response.message;
                // console.log($scope.listaEquipo);
    	});
    }


    //lista de integrantes de equipo
    $scope.listarEquipo($scope.proyectoId);
   

    $scope.insertarSprintBacklog = function(sprintBacklog){
        // console.log(sprintBacklog)
        sprintServices.insertarSprintBacklog(sprintBacklog).then(function(){
              $scope.vistaSprintCargando = false;
				$scope.listaEquipo = sprintServices.response.message;
                // console.log($scope.listaEquipo);
                 $("#modal-insertar-sprint-backlog").modal("hide");
                  
                      $scope.listarSprintBacklog($scope.dataSprint.id);
                    setTimeout(function() {
                        $scope.listarEsfuerzo($scope.dataSprint.id);    
                    }, 2000);
                    $scope.listarEquipo($scope.proyectoId);
    	});
    }
    //insertar esfuerzo

    $scope.mostrarInsertarEsfuerzo = function(sprintBacklog){
        console.log(sprintBacklog)
        
        $scope.diaEsfuerzo.id_tarea = sprintBacklog.id;
        
        console.log($scope.diaEsfuerzo)
        $("#modal-insertar-esfuerzo").modal();

    }

    $scope.insertarEsfuerzo = function(esfuerzo){
        sprintServices.insertarEsfuerzo(esfuerzo).then(function(){

				$scope.repuestaEsfuerzo = sprintServices.response.message;
                console.log($scope.repuestaEsfuerzo);
                if($scope.repuestaEsfuerzo == 0 ){ alert("Error, la hora ya fue insertada")}
                 $("#modal-insertar-esfuerzo").modal("hide");
                  
                      $scope.listarSprintBacklog($scope.dataSprint.id);
                    setTimeout(function() {
                        $scope.listarEsfuerzo($scope.dataSprint.id);    
                    }, 2000);
                    $scope.listarEquipo($scope.proyectoId);
    	});
    }
}])