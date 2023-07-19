<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userid = $_POST['userid'];
$item_name = $_POST['itemname'];
$item_qty = $_POST['itemqty'];
$item_desc = $_POST['itemdesc'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$state = $_POST['state'];
$locality = $_POST['locality'];
$image1 = $_POST['image1'];
$image2 = $_POST['image2'];
$image3 = $_POST['image3'];

$sqlinsert = "INSERT INTO `tbl_items`(`user_id`,`item_name`, `item_qty`, `item_desc`, `item_lat`, `item_long`, `item_state`, `item_locality`) 
VALUES ('$userid','$item_name','$item_qty','$item_desc','$latitude','$longitude','$state','$locality')";

if ($conn->query($sqlinsert) === TRUE) {
	$filename = mysqli_insert_id($conn);
	$response = array('status' => 'success', 'data' => null);
	$decoded_string1 = base64_decode($image1);
	$decoded_string2 = base64_decode($image2);
	$decoded_string3 = base64_decode($image3);
	$path1 = '../assets/items/front/'.$filename.'.png';
	$path2 = '../assets/items/left/'.$filename.'.png';
	$path3 = '../assets/items/right/'.$filename.'.png';
	file_put_contents($path1, $decoded_string1);
	file_put_contents($path2, $decoded_string2);
	file_put_contents($path3, $decoded_string3);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>