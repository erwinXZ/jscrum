<?php 

namespace App\Model;

use App\Lib\Response,
	App\Lib\Security;

/**
* Modelo usuario
*/
class  UsuarioModel
{
	private $db;
	private $table = 'usuario';
	private $response;



	public function __CONSTRUCT($db, $db_pdo){
		$this->db 		= $db;
		$this->db_pdo   = $db_pdo;
		$this->response = new Response();
		$this->security = new Security();
	}

	//var $l => 'limit', $p => 'pagina'

	//lista_total
	public function listar(){

		return $data = $this->db->from($this->table)
						 ->orderBy('id DESC')
						 ->fetchAll();
	//  return $data = $this->db_pdo->query('select * from '.$this->table)
	//					 			->fetchAll();				   						 
	}

	//listar paginado
	//parametros de limite, pagina
	public function paginated($l, $p){	
		$p = $p*$l;
		$data = $this->db->from($this->table)
						 ->limit($l)
						 ->offset($p)
						 ->orderBy('id desc')
						 ->fetchAll();

		$total = $this->db->from($this->table)
						  ->select('COUNT(*) Total')
						  ->fetch()
						  ->Total;

		return [
			'data'	=>   $data,
			'total' =>   $total

		];				  						 
	}
	//obtener
	public function getUsuario($id){

		return $data = $this->db->from($this->table, $id)
								->fetch();  						 
	}
	//registrar

	public function insert($data){

		//$this->db->insertInto($this->table, $data)
		//		 ->execute();
		// $this->db_pdo->prepare(" CALL insertarUsuario(	'".$data['_nombre']."',
		// 											'".$data['_apellidos']."',
		// 											'".$data['_email']."',
        //                                             '".$data['_login']."',
        //                                             '".$data['_password']."',
		// 											'".$data['_profesion']."')")
		// 			  ->execute();

		// return $this->response->setResponse(true);
		$this->db_pdo->multi_query(" CALL insertarUsuario(	'".$data['_nombre']."',
		 											'".$data['_apellidos']."',
		 											'".$data['_email']."',
                                                     '".$data['_login']."',
                                                     '".$data['_password']."',
                                                     '".$data['_profesion']."',
		 											'".$data['_rol']."');");
			$res = $this->db_pdo->store_result();
			$res = $res->fetch_array();
			mysqli_close($this->db_pdo);
			$res = array("message"=>$res[0],"response"=>true);
			return $res;										 

			 
	}

    public function insertManager($data){

		//$this->db->insertInto($this->table, $data)
		//		 ->execute();
		$this->db_pdo->prepare(" CALL insertarManager(	'".$data['_experiencia']."',
													'".$data['_email']."')")
					  ->execute();
		return $this->response->setResponse(true);
			 
	}

    public function insertMiembro($data){

		//$this->db->insertInto($this->table, $data)
		//		 ->execute();
		$this->db_pdo->prepare(" CALL insertarMiembro(	'".$data['_destrezas']."',
													'".$data['_email']."')")
					  ->execute();
		return $this->response->setResponse(true);
			 
	}

	public function asignRol($data){

		$this->db_pdo->multi_query(" CALL asignarRol('".$data['_id']."',
		 											'".$data['_rol']."');");
			$res = $this->db_pdo->store_result();
			$res = $res->fetch_array();
			mysqli_close($this->db_pdo);
			$res = array("message"=>$res[0],"response"=>true);
			return $res;										 

			 
	}

	public function login($data){

		//$this->db->insertInto($this->table, $data)
		//		 ->execute();
		$this->db_pdo->multi_query("CALL login('".$data['_login']."',
											'".$data['_password']."')");
		$res = $this->db_pdo->store_result();
			$res = $res->fetch_assoc();
			mysqli_close($this->db_pdo);

			$res = array("mesagge"=>$res);
			$res["response"]=true;
			return $res;										 

			 
	}
	//actualizar
	public function update($data, $id){

		if (isset($data['password'])) {
			$data['password'] = $this->security->encriptar($data['password']);	
		}

		$this->db->update($this->table, $data, $id)	
				 ->execute();

		return $this->response->setResponse(true);		 
	}
	//eliminar
	public function delete($id){

		$this->db->deleteFrom($this->table, $id)	
				 ->execute();

		return $this->response->setResponse(true);		 
	}

}

 ?>