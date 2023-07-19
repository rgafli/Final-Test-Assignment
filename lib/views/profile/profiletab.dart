// ignore_for_file: non_constant_identifier_names, prefer_const_constructors
import 'dart:convert';

import 'package:barterit/models/user.dart';
import 'package:barterit/myconfig.dart';
import 'package:barterit/views/profile/buycoinscreen.dart';
import 'package:barterit/views/profile/loginscreen.dart';
import 'package:barterit/views/profile/profilesetting.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileTab extends StatefulWidget {
  final User user;
  const ProfileTab({super.key, required this.user});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String maintitle = "Profile";
  late double screenHeight, screenWidth, cardwitdh;
  late User user;
  final df = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(maintitle),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        elevation: 5,
        actions: [
          IconButton(
            onPressed: () {
              LogoutUser();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: screenWidth * 0.6,
                child: PageView(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(4),
                      width: screenWidth * 0.4,
                      child: Image.asset(
                        "assets/images/profile2.png",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
            ),
            buildTable(),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (content) => ProfileSetting(
                          user: widget.user,
                        ),
                      ),
                    );
                  },
                  child: Text('Setting', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (content) => BuyCoinScreen(user: widget.user),
                      ),
                    );
                  },
                  child:
                      Text('Buy Coins', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTable() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(4),
          1: FlexColumnWidth(6),
        },
        children: [
          buildTableRow("Name", widget.user.name.toString()),
          buildTableRow("Email", widget.user.email.toString()),
          buildTableRow(
            "Date",
            df.format(DateTime.parse(widget.user.datareg.toString())),
          ),
          buildTableRow("Coin", widget.user.coin.toString()),
        ],
      ),
    );
  }

  TableRow buildTableRow(String title, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(value),
        ),
      ],
    );
  }

  Widget buildImageCard({required String imageUrl}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        child: CachedNetworkImage(
          width: screenWidth,
          fit: BoxFit.cover,
          imageUrl: imageUrl,
          placeholder: (context, url) => const LinearProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }

  void loadData() {
    http.post(Uri.parse("${MyConfig().SERVER}/barteritphp/php/load_user.php"),
        body: {"email": widget.user.email}).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata != null && jsondata['status'] == "success") {
          var userData = jsondata['data'];
          if (userData != null) {
            setState(() {
              widget.user.name = userData['name'];
              widget.user.email = userData['email'];
              widget.user.datareg = userData['datareg'];
              widget.user.coin = userData['coin'];
            });
          }
        }
      }
    });
  }

  void LogoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
