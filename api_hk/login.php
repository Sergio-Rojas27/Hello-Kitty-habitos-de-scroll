<?php
// 1. Incluir la conexión (esto trae los headers y la variable $conn)
include 'conex.php'; 

// 2. Recibir datos de Flutter
$email = $_POST['email'] ?? '';
$pass  = $_POST['password'] ?? '';

// 3. Preparar la consulta
// Nota: Asegúrate de que la columna se llame 'correo_electronico' en tu tabla 'usuarios'
$sql = "SELECT * FROM usuarios WHERE email = ?";

// AQUÍ ES DONDE DABA EL ERROR: Usamos $conn que viene de conex.php
if ($stmt = $conn->prepare($sql)) {
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $resultado = $stmt->get_result();

    if ($user = $resultado->fetch_assoc()) {
        // 4. Verificar contraseña (usando el hash que guardamos en el registro)
        if ($pass === $user['password']) {
            echo json_encode([
                "status" => "success", 
                "message" => "Bienvenido",
                "id" => $user['id']
            ]);
        } else {
            echo json_encode(["status" => "error", "message" => "Contraseña incorrecta"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Usuario no encontrado"]);
    }
    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Error en la consulta SQL"]);
}

$conn->close();
?>