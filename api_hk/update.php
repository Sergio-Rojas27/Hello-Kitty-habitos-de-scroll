<?php
header('Content-Type: application/json');
include 'conex.php';

// Leer la entrada cruda
$json = file_get_contents("php://input");
$data = json_decode($json, true);

// --- BLOQUE DE DEPURACIÓN ---
if (empty($json)) {
    echo json_encode([
        "status" => "error", 
        "message" => "El cuerpo de la petición está totalmente vacío (Empty body)"
    ]);
    exit();
}

if (is_null($data)) {
    echo json_encode([
        "status" => "error", 
        "message" => "El JSON no se pudo decodificar",
        "recibido_crudo" => $json 
    ]);
    exit();
}
// ----------------------------

if (isset($data['id_usuario']) && isset($data['nuevo_pin'])) {
    $id_usuario = $data['id_usuario'];
    $nuevo_pin = $data['nuevo_pin'];

    if (strlen($nuevo_pin) !== 4) {
        echo json_encode(["status" => "error", "message" => "El PIN debe tener 4 dígitos"]);
        exit();
    }

    $stmt = $conn->prepare("UPDATE tutor SET pin_tutor = ? WHERE id_usuario = ?");
    $stmt->bind_param("si", $nuevo_pin, $id_usuario);

    if ($stmt->execute()) {
        echo json_encode([
            "status" => "success", 
            "message" => "PIN actualizado",
            "filas_afectadas" => $stmt->affected_rows
        ]);
    } else {
        echo json_encode(["status" => "error", "message" => "Error SQL: " . $stmt->error]);
    }
    $stmt->close();
} else {
    // Si entra aquí, te dirá qué llaves sí recibió
    echo json_encode([
        "status" => "error", 
        "message" => "Datos incompletos",
        "llaves_recibidas" => array_keys($data)
    ]);
}
$conn->close();
?>