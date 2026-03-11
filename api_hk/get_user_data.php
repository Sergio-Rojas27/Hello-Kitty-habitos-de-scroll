<?php
include 'conex.php';
$id = $_GET['id_usuario'] ?? '';

$sql = "SELECT u.email, t.nombre_completo as nombre_tutor, n.nombre_nino 
        FROM usuarios u 
        JOIN tutor t ON u.id = t.id_usuario 
        JOIN nino n ON u.id = n.id_usuario 
        WHERE u.id = ?";

$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $id);
$stmt->execute();
$res = $stmt->get_result();
echo json_encode($res->fetch_assoc());
?>