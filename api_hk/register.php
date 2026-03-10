<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

include 'conex.php'; 

// Usamos $_POST directamente
$email = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';
$pin = $_POST['pin'] ?? '';
$nombre_tutor = $_POST['nombre_tutor'] ?? '';
$nombre_nino = $_POST['nombre_nino'] ?? '';

// Debug para que veas en la consola de Flutter qué recibió el PHP
if (empty($email)) {
    echo json_encode([
        "status" => "error", 
        "message" => "El servidor no detectó el email",
        "recibido" => $_POST 
    ]);
    exit;
}

// ... (El resto de tu código de INSERT sigue igual)
// 2. Insertar en 'usuarios'
$sql_user = "INSERT INTO usuarios (email, password) VALUES ('$email', '$password')";

if ($conn->query($sql_user) === TRUE) {
    $id_usuario = $conn->insert_id; 

    // 3. Manejar fotos
    $ruta_tutor = "uploads/tutors/default.png";
    $ruta_nino = "uploads/kids/default.png";

    if (isset($_FILES['foto_tutor']) && $_FILES['foto_tutor']['error'] === UPLOAD_ERR_OK) {
        $ext = pathinfo($_FILES['foto_tutor']['name'], PATHINFO_EXTENSION);
        $ruta_tutor = "uploads/tutors/" . $id_usuario . "_tutor." . $ext;
        move_uploaded_file($_FILES['foto_tutor']['tmp_name'], $ruta_tutor);
    }
    
    if (isset($_FILES['foto_nino']) && $_FILES['foto_nino']['error'] === UPLOAD_ERR_OK) {
        $ext = pathinfo($_FILES['foto_nino']['name'], PATHINFO_EXTENSION);
        $ruta_nino = "uploads/kids/" . $id_usuario . "_nino." . $ext;
        move_uploaded_file($_FILES['foto_nino']['tmp_name'], $ruta_nino);
    }

    // 4. Insertar en perfiles
    $sql_tutor = "INSERT INTO tutor (id_usuario, nombre_completo, pin_tutor, foto_perfil) 
                  VALUES ($id_usuario, '$nombre_tutor', '$pin', '$ruta_tutor')";
                  
    $sql_nino = "INSERT INTO nino (id_usuario, nombre_nino, foto_perfil) 
                 VALUES ($id_usuario, '$nombre_nino', '$ruta_nino')";

    if ($conn->query($sql_tutor) && $conn->query($sql_nino)) {
        echo json_encode(["status" => "success", "message" => "¡Registro guardado!"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Error en perfiles: " . $conn->error]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Error en cuenta: " . $conn->error]);
}
$conn->close();
?>