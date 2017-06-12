<?php 

namespace App\Model;

use App\Lib\Response,
	App\Lib\Security;

/**
* Modelo usuario
*/
class  ProyectoModel
{
	private $db;
	private $table = 'proyecto';
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
	public function getProyecto($id){

		return $data = $this->db->from($this->table, $id)
								->fetch();  						 
	}
	//registrar

	public function insert($data){
		//$this->db->insertInto($this->table, $data)
		//		 ->execute();
		$this->db_pdo->multi_query(" CALL crearProyecto('".$data['_codigo']."',
													'".$data['_nombre']."',
													'".$data['_descripcion']."',
													'".$data['_objetivo']."',
													'".$data['_id_manager']."',
													'".$data['_id_equipo']."')");
			$res = $this->db_pdo->store_result();
			$res = $res->fetch_array();
			mysqli_close($this->db_pdo);
			$res = array("message"=>$res[0],"response"=>true);
			return $res;		
	}

	public function insertProyectoSprint($data){

		$this->db_pdo->multi_query(" CALL insertarProyectoSprint('".$data['_codigo']."',
													'".$data['_historia']."',
													'".$data['_importancia']."',
													'".$data['_estimado']."',
                                                    '".$data['_codigoS']."',
													'".$data['_id_proyecto']."')");		
			$res = $this->db_pdo->store_result();
			$res = $res->fetch_array();
			mysqli_close($this->db_pdo);
			$res = array("message"=>$res[0],"response"=>true);
			return $res;	 
	}

	public function listarProyectos($data){
		$this->db_pdo->multi_query(" CALL listarProyectos(".$data.")");
			$res = $this->db_pdo->store_result();
			while($fila = $res->fetch_assoc()){
				$arreglo[] = $fila;
			}
			$res = $arreglo;
			mysqli_close($this->db_pdo);
			$res = array("message"=>$res,"response"=>true);
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