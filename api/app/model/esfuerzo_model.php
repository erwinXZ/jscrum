<?php 

namespace App\Model;

use App\Lib\Response,
	App\Lib\Security;

/**
* Modelo usuario
*/
class  EsfuerzoModel
{
	private $db;
	private $table = 'esfuerzo';
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
	public function getEsfuerzo($id){

		return $data = $this->db->from($this->table, $id)
								->fetch();  						 
	}
	//registrar

	public function insert($data){

		//$this->db->insertInto($this->table, $data)
		//		 ->execute();
		$this->db_pdo->prepare(" CALL quemarHoras(	'".$data['_cantidad']."',
													'".$data['_id_tarea']."')")
					  ->execute();

		return $this->response->setResponse(true);
			 
	}

	public function listarEsfuerzo($data){
		$this->db_pdo->multi_query(" CALL listarEsfuerzo(".$data.")");
			$res = $this->db_pdo->store_result();

			while($fila = $res->fetch_assoc()){
				$arreglo[] = $fila;
			}
			$res = $arreglo;
			$res = array("message"=>$res,"response"=>true);
			
			// $res = $res->fetch_array();
			// mysqli_close($this->db_pdo);
			
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