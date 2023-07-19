<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$buyerid = $_POST['buyer_id'];
$buyername = $_POST['buyer_name'];
$sellerid = $_POST['seller_id'];
$sellername = $_POST['seller_name'];
$buyeritemid = $_POST['buyer_item_id'];
$selleritemid = $_POST['seller_item_id'];

$sqlfind = "SELECT `user_name` FROM `tbl_users` WHERE `user_id` = '$sellerid'";
$sellerNameResult = $conn->query($sqlfind);
$sellerName = "";
if ($sellerNameResult->num_rows > 0) {
    $sellerRow = $sellerNameResult->fetch_assoc();
    $sellerName = $sellerRow['user_name'];
}

$sqlinsert = "INSERT INTO `tbl_order` ( `buyer_id` , `buyer_name` , `seller_id` , `seller_name` , `buyer_item_id` , `seller_item_id` , `order_status`) VALUES ('$buyerid' , '$buyername' , '$sellerid' , '$sellerName' , '$buyeritemid' , '$selleritemid' , 'pending')";
if ($conn->query($sqlinsert) === TRUE) {
	$response = array('status' => 'success', 'data' => $sqlinsert);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => $sqlinsert);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>