<?php
// Incluimos el archivo de conexión que ya creaste
require 'conex.php';

// Leemos los datos JSON enviados en el cuerpo de la petición
$data = json_decode(file_get_contents("php://input"));

// Verificamos que se haya enviado un ID válido
if (!isset($data->id) || empty($data->id)) {
    echo json_encode(["status" => "error", "message" => "No se proporcionó el ID del usuario"]);
    exit();
}

$id_usuario = $data->id;

// Utilizamos sentencias preparadas (Prepared Statements) para evitar Inyección SQL
$sql = "DELETE FROM usuarios WHERE id = ?";
$stmt = $conn->prepare($sql);

if ($stmt) {
    // Vinculamos el parámetro (la "i" indica que es un número entero)
    $stmt->bind_param("i", $id_usuario);
    
    // Ejecutamos la consulta
    if ($stmt->execute()) {
        // Comprobamos si realmente se eliminó alguna fila
        if ($stmt->affected_rows > 0) {
            echo json_encode(["status" => "success", "message" => "Usuario y perfiles asociados eliminados correctamente"]);
        } else {
            echo json_encode(["status" => "error", "message" => "No se encontró un usuario con ese ID"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Error al ejecutar la consulta: " . $stmt->error]);
    }
    
    // Cerramos el statement
    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Error al preparar la consulta: " . $conn->error]);
}

// Cerramos la conexión
$conn->close();
?>