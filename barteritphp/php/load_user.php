<?php
if (!isset($_POST['email'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

$email = $_POST['email'];

include_once("dbconnect.php");

$sqluser = "SELECT * FROM `tbl_users` WHERE user_email = '$email'";
$result = $conn->query($sqluser);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $userarray = array();
    $userarray['email'] = $row['user_email'];
    $userarray['name'] = $row['user_name'];
    $userarray['datareg'] = $row['user_datareg'];
    $userarray['coin'] = $row['user_coin'];
    $response = array('status' => 'success', 'data' => $userarray);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
