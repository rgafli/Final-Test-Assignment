import 'dart:convert';

import 'package:barterit/models/user.dart';
import 'package:barterit/myconfig.dart';
import 'package:barterit/views/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Coins {
  final int amount;
  final int price;

  Coins({required this.amount, required this.price});
}

class BuyCoinScreen extends StatefulWidget {
  final User user;
  const BuyCoinScreen({super.key, required this.user});

  @override
  State<BuyCoinScreen> createState() => _BuyCoinScreenState();
}

class _BuyCoinScreenState extends State<BuyCoinScreen> {
  String maintitle = 'Coins Shop';
  List<Coins> coin = [
    Coins(amount: 10, price: 5),
    Coins(amount: 15, price: 10),
    Coins(amount: 20, price: 15),
    Coins(amount: 30, price: 25),
    Coins(amount: 40, price: 35),
    Coins(amount: 60, price: 50),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(maintitle),
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
          elevation: 5,
          leading: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainScreen(user: widget.user)),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.arrow_back_rounded))),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: coin.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              confirmDialog(coin[index]);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8.0),
                    Text(
                      '${coin[index].amount} Coins',
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    Text(
                      'Price: ${coin[index].price} RM',
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void confirmDialog(Coins coin) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Buy Coins",
            style: TextStyle(),
          ),
          content: Text(
            "Are you sure you want to buy\n ${coin.amount} Coin for ${coin.price} RM?",
            style: const TextStyle(),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                updateCoin(coin);
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void updateCoin(Coins coin) {
    int addCoin = coin.amount;
    String status = "buy";
    http.post(Uri.parse("${MyConfig().SERVER}/barteritphp/php/update_coin.php"),
        body: {
          "user_id": widget.user.id.toString(),
          "coins": addCoin.toString(),
          "status": status.toString()
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Buy Success")));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Buy Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Buy Failed")));
      }
    });
  }
}
