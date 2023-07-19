// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:barterit/models/user.dart';
import 'package:barterit/myconfig.dart';
import 'package:barterit/views/profile/loginscreen.dart';
import 'package:barterit/views/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkAndLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.lightGreen,
              image: DecorationImage(
                image: AssetImage('assets/images/splashscreen.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Barter IT",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                CircularProgressIndicator(),
                Text(
                  "Version 0.1",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void checkAndLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';
    String password = prefs.getString('pass') ?? '';
    bool isCheck = prefs.getBool('checkbox') ?? false;

    if (isCheck) {
      try {
        http.Response response = await http.post(
          Uri.parse("${MyConfig().SERVER}/barteritphp/php/login_user.php"),
          body: {"email": email, "password": password},
        ).timeout(const Duration(seconds: 5));

        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == 'success') {
            User user = User.fromJson(jsondata['data']);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (content) => MainScreen(user: user),
              ),
            );
            return;
          }
        }
      } on TimeoutException catch (_) {
        print("Time out");
      }
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => const LoginScreen())));
    }

    // Redirect to the login screen
  }
}
