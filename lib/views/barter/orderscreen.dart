import 'dart:convert';

import 'package:barterit/models/order.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/myconfig.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderScreen extends StatefulWidget {
  final User user;
  const OrderScreen({super.key, required this.user});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String maintitle = "Order List";
  late double screenHeight, screenWidth;
  List<Order> orderList = <Order>[];

  @override
  void initState() {
    super.initState();
    loadOrder();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        title: Text(maintitle),
      ),
      body: orderList.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : ListView.builder(
              itemCount: orderList.length,
              itemBuilder: (context, index) {
                final order = orderList[index];
                bool isBuyer = order.buyerId == widget.user.id;

                Widget itemWidget;

                if (order.orderStatus == 'pending' && !isBuyer) {
                  itemWidget = Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          confirmBarter(order);
                        },
                        child: const Text('Confirm'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          rejectBarter(order);
                        },
                        child: const Text('Reject'),
                      ),
                    ],
                  );
                } else {
                  itemWidget = Text(
                    order.orderStatus.toString(),
                    style: const TextStyle(fontSize: 16),
                  );
                }

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              CachedNetworkImage(
                                width: screenWidth,
                                height: 120,
                                fit: BoxFit.cover,
                                imageUrl:
                                    "${MyConfig().SERVER}/barteritphp/assets/items/front/${order.buyerItemId}.png",
                                placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                order.buyerName.toString(),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              itemWidget,
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              CachedNetworkImage(
                                width: screenWidth,
                                height: 120,
                                fit: BoxFit.cover,
                                imageUrl:
                                    "${MyConfig().SERVER}/barteritphp/assets/items/front/${order.sellerItemId}.png",
                                placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                order.sellerName.toString(),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void loadOrder() {
    http.post(Uri.parse("${MyConfig().SERVER}/barteritphp/php/load_order.php"),
        body: {"user_id": widget.user.id}).then((response) {
      orderList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['order'].forEach((v) async {
            Order order = Order.fromJson(v);
            orderList.add(order);
          });
        }
        setState(() {});
      }
    });
  }

  void confirmBarter(Order order) {
    order.orderStatus = 'confirmed';
    sendOrderStatus(order);
  }

  void rejectBarter(Order order) {
    order.orderStatus = 'rejected';
    sendOrderStatus(order);
  }

  void sendOrderStatus(Order order) {
    http.post(
      Uri.parse("${MyConfig().SERVER}/barteritphp/php/update_order.php"),
      body: {
        'order_id': order.orderId.toString(),
        'new_status': order.orderStatus.toString(),
        'buyer_item_id': order.buyerItemId.toString(),
        'seller_item_id': order.sellerItemId.toString(),
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Order status updated")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to update order status")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update order status")),
        );
      }
    });
  }
}
