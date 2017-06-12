<?php 

namespace App\Model;

use App\Lib\Response,
	App\Lib\Security;

/**
* Modelo usuario
*/
class  SprintModel
{
	private $db;
	private $table = 'sprint';
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
	public function getSprint($id){

		return $data = $this->db->from($this->table, $id)
								->fetch();  						 
	}
	//registrar

	public function insert($data){
		$this->db_pdo->multi_query(" CALL crearSprint('".$data['_codigo']."',
													'".$data['_fecha_entrega']."')");		
			$res = $this->db_pdo->store_result();
			$res = $res->fetch_array();
			mysqli_close($this->db_pdo);
			$res = array("message"=>$res[0],"response"=>true);
			return $res;
			 
	}

	public function insertPS($data){

		//$this->db->insertInto($this->table, $data)
		//		 ->execute();
		$this->db_pdo->multi_query(" CALL insertarProyectoSprint('".$data['_codigo']."',
													'".$data['_historia']."',
													'".$data['_importancia']."',
													'".$data['_estimado_horas']."',
                                                    '".$data['_id_sprint']."',
													'".$data['_id_proyecto']."')");
			$res = $this->db_pdo->store_result();
			$res = $res->fetch_array();
			mysqli_close($this->db_pdo);
			$res = array("message"=>$res[0],"response"=>true);
			return $res;
			 
	}

	public function insertDiasInhabiles($data){

		//$this->db->insertInto($this->table, $data)
		//		 ->execute();
		$this->db_pdo->multi_query(" CALL insertarDiaInhabil('".$data['_dia_inhabil']."',
													'".$data['_id_sprint']."')");
			$res = $this->db_pdo->store_result();
			$res = $res->fetch_array();
			mysqli_close($this->db_pdo);
			$res = array("message"=>$res[0],"response"=>true);
			return $res;
			 
	}

	public function listarSprint($data){
		$this->db_pdo->multi_query(" CALL listarSprint(".$data.")");
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