<?php 

namespace App\Model;

use App\Lib\Response,
	App\Lib\Security;

/**
* Modelo usuario
*/
class  TareaModel
{
	private $db;
	private $table = 'tarea';
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
	public function getTarea($id){

		return $data = $this->db->from($this->table, $id)
								->fetch();  						 
	}
	//registrar

	public function insert($data){

		//$this->db->insertInto($this->table, $data)
		//		 ->execute();
		$this->db_pdo->prepare(" CALL asignarTarea(	'".$data['_descripcion']."',
													'".$data['_tipo']."',
													'".$data['_total_horas']."',
                                                    '".$data['_id_sprint']."',
													'".$data['_id_miembro']."')")
					  ->execute();

		return $this->response->setResponse(true);
			 
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