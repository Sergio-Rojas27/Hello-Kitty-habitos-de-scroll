<?php
include 'conex.php';

$id_usuario = $_POST['id_usuario'] ?? '';
$pin = $_POST['pin'] ?? '';

if (empty($id_usuario) || empty($pin)) {
    echo json_encode(["status" => "error", "message" => "Datos incompletos"]);
    exit;
}

// Buscamos en la tabla tutor el registro que coincida con el usuario logueado
$sql = "SELECT nombre_completo FROM tutor WHERE id_usuario = '$id_usuario' AND pin_tutor = '$pin'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    // Enviamos el nombre real en la respuesta
    echo json_encode([
        "status" => "success",
        "nombre_tutor" => $row['nombre_completo'] 
    ]);
} else {
    echo json_encode(["status" => "error", "message" => "PIN incorrecto"]);
}
?>

