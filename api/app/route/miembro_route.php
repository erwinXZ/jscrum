<?php 
use App\Lib\Response;

	$app->add(function ($req, $res, $next) {
    $response = $next($req, $res);
    return $response
            ->withHeader('Access-Control-Allow-Origin', 'http://localhost')
            ->withHeader('Access-Control-Allow-Headers', 'X-Requested-With, Content-Type, Accept, Origin, Authorization')
            ->withHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
});

$app->group('/miembro',function(){

	$this->get('/',function($req, $res, $args){
		return $res->withHeader('Content-type', 'aplication/json')
				   ->write(
				   		json_encode($this->model->Miembro->listar())
				   	);	
	});

		// $this->get('listar-paginado/{l}/{p}',function($req, $res, $args){
		// 	return $res->withHeader('Content-type', 'aplication/json')
		// 			   ->write(
		// 			   		json_encode($this->model->User->paginated($args['l'], $args['p']))
					   		
		// 			   	);
		// });

	$this->get('/{id}',function($req, $res, $args){
		return $res->withHeader('Content-type', 'aplication/json')
				   ->write(
				   		json_encode($this->model->Miembro->getMiembro($args['id']))
				   		
				   	);
	});

	$this->post('/',function($req, $res, $args){
		// $r = UserValidation::validate($req->getParsedBody());

		// if(!$r->response){
		// 	return $res->withHeader('Content-type', 'aplication/json')
		// 			   ->withStatus(422)
		// 			   ->write(json_encode($r->errors));
		// }

		return $res->withHeader('Content-type', 'aplication/json')
			       -> write(
						json_encode($this->model->Miembro->insert($req->getParsedBody()))

				   	);
	});

	$this->put('/{id}',function($req, $res, $args){

		// $r = UserValidation::validate($req->getParsedBody());

		// if(!$r->response){
		// 	return $res->withHeader('Content-type', 'aplication/json')
		// 			   ->withStatus(422)
		// 			   ->write(json_encode($r->errors));
		// }
		
		return $res->withHeader('Content-type', 'aplication/json')
				   ->write(
				   		json_encode($this->model->Miembro->update($req->getParsedBody(), $args['id'] ))
				   		
				   	);
	});

	$this->delete('/{id}',function($req, $res, $args){
		return $res->withHeader('Content-type', 'aplication/json')
				   ->write(
				   		json_encode($this->model->Miembro->delete($args['id']))
				   		
				   	);

	});
});	
// })->add(new AuthMiddleware($app)); //agregar middleware

 ?>