<?php
include 'conex.php';
$id = $_POST['id_usuario'];
// Al borrar el usuario, por FK (si configuraste CASCADE) se borra lo demás. 
// Si no, borra manualmente tutor y nino primero.
$sql = "DELETE FROM usuarios WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $id);
if($stmt->execute()) echo json_encode(["status" => "success"]);
?>