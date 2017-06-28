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
		$this->db_pdo->multi_query(" CALL quemarHoras('".$data['_cantidad']."',
													'".$data['_id_tarea']."',
													'".$data['_id_sprint']."')");
			$res = $this->db_pdo->store_result();
			$res = $res->fetch_array();
			mysqli_close($this->db_pdo);
			$res = array("message"=>$res[0],"response"=>true);
			return $res;	
	}

	public function listarEsfuerzo($data){
		$this->db_pdo->multi_query(" CALL listarEsfuerzo(".$data.")");
			$res1 = $this->db_pdo->store_result();

			while($fila = $res1->fetch_assoc()){
				$arreglo[] = $fila;
			}
			$res1 = $arreglo;
			// $res1 = array("message"=>$res1,"response"=>true);
			
		// $this->db_pdo->multi_query(" CALL listarTareas(".$data.")");
		// 	$res2 = $this->db_pdo->store_result();
		// 	while($fila1 = $res2->fetch_assoc()){
		// 		$arreglo1[] = $fila1;
		// 	}
		// 	$res2 = $arreglo1;
		// 	// $res2 = array("message"=>$res2,"response"=>true);

			$auxEsfuerzo = $res1;
		// 	$auxTarea = $res2;

		// 	foreach($auxTarea as $valor2){
				foreach($auxEsfuerzo as $valor1){
					// if ($valor2[id] == $valor1[id_tarea]){
						$valor1[cant] = explode(",", $valor1[cantidades]);
						// $valor1[cant] = $valor1[cantidades];
						$valor2[cant]=asort($valor1[cant]);
					}
		// 		}

		// 	}

		// 	$res = $auxTarea;

			return $auxEsfuerzo;
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