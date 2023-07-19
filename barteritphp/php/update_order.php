<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$orderid = $_POST['order_id']; 
$newStatus = $_POST['new_status'];
$buyeritemid = $_POST['buyer_item_id'];
$selleritemid = $_POST['seller_item_id'];

$sqlselectOrder = "SELECT * FROM `tbl_order` WHERE `order_id` = '$orderid'";
$resultOrder = $conn->query($sqlselectOrder);

if ($resultOrder && $resultOrder->num_rows > 0) {
    if ($newStatus == 'confirmed') {
        $sqlUpdateStatus = "UPDATE `tbl_order` SET `order_status` = 'Success' WHERE `order_id` = '$orderid'";
        $conn->query($sqlUpdateStatus);

        //buyer item
        //item qty will decrease
        $sqlupdate = "UPDATE `tbl_items` SET `item_qty` = `item_qty` - 1 WHERE `item_id` = '$buyeritemid'";
        $conn->query($sqlupdate);

        //check for item if < 1
        $sqlselectBuyerItem = "SELECT `item_qty` FROM `tbl_items` WHERE `item_id` = '$buyeritemid'";
        $resultBuyerItem = $conn->query($sqlselectBuyerItem);
        if ($resultBuyerItem && $resultBuyerItem->num_rows > 0) {
            $rowBuyerItem = $resultBuyerItem->fetch_assoc();
            $itemqty = $rowBuyerItem['item_qty'];
        }

        //seller item
        //item qty will decrease
        $sqlupdate2 = "UPDATE `tbl_items` SET `item_qty` = `item_qty` - 1 WHERE `item_id` = '$selleritemid'";
        $conn->query($sqlupdate2);

        //check for item if < 1
        $sqlselectSellerItem = "SELECT `item_qty` FROM `tbl_items` WHERE `item_id` = '$selleritemid'";
        $resultSellerItem = $conn->query($sqlselectSellerItem);
        if ($resultSellerItem && $resultSellerItem->num_rows > 0) {
            $rowSellerItem = $resultSellerItem->fetch_assoc();
            $itemqty2 = $rowSellerItem['item_qty'];
        }

        $response = array('status' => 'success', 'data' => $sqlselectOrder);
        sendJsonResponse($response);
    } else {
        $sqlUpdateStatus = "UPDATE `tbl_order` SET `order_status` = 'Rejected' WHERE `order_id` = '$orderid'";
        $conn->query($sqlUpdateStatus);

        $response = array('status' => 'success', 'data' => $sqlselectOrder);
        sendJsonResponse($response);
    }
} else {
    $response = array('status' => 'failed', 'data' => $orderid);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>
