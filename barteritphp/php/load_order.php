<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userid = $_POST['user_id'];
$sqlloaditems = "SELECT * FROM `tbl_order` WHERE `buyer_id` = '$userid' OR `seller_id` = '$userid'";
$result = $conn->query($sqlloaditems);

if ($result->num_rows > 0) {
    $order["order"] = array();
    while ($row = $result->fetch_assoc()) {
        $orderlist = array();
        $orderlist['order_id'] = $row['order_id'];
        $orderlist['buyer_id'] = $row['buyer_id'];
        $orderlist['seller_id'] = $row['seller_id'];
        $orderlist['buyer_item_id'] = $row['buyer_item_id'];
        $orderlist['seller_item_id'] = $row['seller_item_id'];
        $orderlist['order_status'] = $row['order_status'];
        $orderlist['buyer_name'] = $row['buyer_name'];
        $orderlist['seller_name'] = $row['seller_name'];
        array_push($order["order"], $orderlist);
    }
    
    $response = array('status' => 'success', 'data' => $order);
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
