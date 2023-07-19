<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$name = $_POST['name'];
$email = $_POST['email'];
$password = sha1($_POST['password']);

$sqlupdate = "UPDATE `tbl_users` SET `user_name` = '$name' , `user_password` = '$password' WHERE `user_email` LIKE '$email'";
    if ($conn->query($sqlupdate) === TRUE) {
	    $response = array('status' => 'success', 'data' => $sqlupdate);
        sendJsonResponse($response);
    }else{
	    $response = array('status' => 'failed', 'data' => $sqlupdate);
	    sendJsonResponse($response);
    }



function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>