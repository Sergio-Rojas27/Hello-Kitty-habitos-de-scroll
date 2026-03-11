<?php
include 'conex.php';
$id = $_POST['id_usuario'];
$nombre_tutor = $_POST['nombre_tutor'];
$nombre_nino = $_POST['nombre_nino'];
$email = $_POST['email'];

$sql1 = "UPDATE usuarios SET email = ? WHERE id = ?";
$sql2 = "UPDATE tutor SET nombre_completo = ? WHERE id_usuario = ?";
$sql3 = "UPDATE nino SET nombre_nino = ? WHERE id_usuario = ?";

$conn->begin_transaction();
try {
    $stmt1 = $conn->prepare($sql1); $stmt1->bind_param("si", $email, $id); $stmt1->execute();
    $stmt2 = $conn->prepare($sql2); $stmt2->bind_param("si", $nombre_tutor, $id); $stmt2->execute();
    $stmt3 = $conn->prepare($sql3); $stmt3->bind_param("si", $nombre_nino, $id); $stmt3->execute();
    $conn->commit();
    echo json_encode(["status" => "success"]);
} catch (Exception $e) {
    $conn->rollback();
    echo json_encode(["status" => "error"]);
}
?>