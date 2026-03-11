<?php
include 'conex.php';

// Recibir los datos en formato JSON
$data = json_decode(file_get_contents("php://input"), true);

if (isset($data['id_usuario']) && isset($data['nuevo_pin'])) {
    $id_usuario = $data['id_usuario'];
    $nuevo_pin = $data['nuevo_pin'];

    // Validar que el PIN sea de 4 dígitos
    if (strlen($nuevo_pin) !== 4) {
        echo json_encode(["status" => "error", "message" => "El PIN debe tener 4 dígitos"]);
        exit();
    }

    // Actualizar el PIN en la tabla tutor
    $stmt = $conn->prepare("UPDATE tutor SET pin_tutor = ? WHERE id_usuario = ?");
    $stmt->bind_param("si", $nuevo_pin, $id_usuario);

    if ($stmt->execute()) {
        if ($stmt->affected_rows > 0) {
            echo json_encode(["status" => "success", "message" => "PIN actualizado correctamente"]);
        } else {
            echo json_encode(["status" => "error", "message" => "No se encontró el tutor o el PIN es igual al anterior"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Error al ejecutar la actualización"]);
    }

    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Datos incompletos"]);
}

$conn->close();
?>