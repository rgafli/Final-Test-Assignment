import 'dart:convert';

import 'package:barterit/models/items.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/myconfig.dart';
import 'package:barterit/views/mainscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConfirmationScreen extends StatefulWidget {
  final Items selecteditems;
  final User user;
  final Items useritems;
  const ConfirmationScreen(
      {super.key,
      required this.selecteditems,
      required this.user,
      required this.useritems});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  late double screenHeight, screenWidth;
  String maintitle = "Confirmation";

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selected Item:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      CachedNetworkImage(
                        imageUrl:
                            "${MyConfig().SERVER}/barteritphp/assets/items/front/${widget.selecteditems.itemsId}.png",
                        placeholder: (context, url) =>
                            const LinearProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        title: Text(widget.selecteditems.itemsName.toString()),
                        subtitle:
                            Text('Quantity: ${widget.selecteditems.itemsQty}'),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'User Item:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      CachedNetworkImage(
                        imageUrl:
                            "${MyConfig().SERVER}/barteritphp/assets/items/front/${widget.useritems.itemsId}.png",
                        placeholder: (context, url) =>
                            const LinearProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        title: Text(widget.useritems.itemsName.toString()),
                        subtitle:
                            Text('Description: ${widget.useritems.itemsQty}'),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 100),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                confirm(); // Assuming this function handles the confirmation process
              },
              child: const Text("Barter"),
            ),
          ),
        ],
      ),
    );
  }

  void confirm() {
    User user = widget.user;
    http.post(Uri.parse("${MyConfig().SERVER}/barteritphp/php/add_order.php"),
        body: {
          "buyer_id": widget.user.id,
          "buyer_name": widget.user.name,
          "seller_id": widget.selecteditems.userId,
          "seller_name": widget.selecteditems.userId,
          "buyer_item_id": widget.useritems.itemsId,
          "seller_item_id": widget.selecteditems.itemsId,
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Add Order Success")));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainScreen(user: user)),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Add Order Failed1")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Add Order Failed")));
      }
    });
  }
}
