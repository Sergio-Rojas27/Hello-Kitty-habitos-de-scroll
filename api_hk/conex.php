<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

// CAMBIO AQUÍ: Usamos $conn (con dos 'n')
$conn = new mysqli("localhost", "root", "", "hello_kitty_db");

if ($conn->connect_error) {
    echo json_encode(["status" => "error", "message" => "Error de conexión"]);
    exit();
}

// Añade esto para que no tengas problemas con la 'ñ' de la tabla 'nino'
$conn->set_charset("utf8");
?>