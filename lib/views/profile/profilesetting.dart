import 'dart:convert';

import 'package:barterit/models/user.dart';
import 'package:barterit/myconfig.dart';
import 'package:barterit/views/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileSetting extends StatefulWidget {
  final User user;
  const ProfileSetting({super.key, required this.user});

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  String maintitle = "Profile";
  late double screenHeight, screenWidth, cardwitdh;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final TextEditingController _pass2EditingController = TextEditingController();
  bool _passwordVisible1 = true;
  bool _passwordVisible2 = true;

  @override
  void initState() {
    super.initState();
    _emailEditingController.text = widget.user.email.toString();
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
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                height: screenHeight * 0.25,
                width: screenWidth,
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
              Container(
                width: screenWidth,
                alignment: Alignment.center,
                color: Theme.of(context).colorScheme.background,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                  child: Text(
                    "Profile Setting",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20.0),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameEditingController,
                        //validate name
                        validator: (val) => val!.isEmpty || (val.length < 3)
                            ? "name must be longer than 3"
                            : null,
                        decoration: const InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.person),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0))),
                      ),
                      TextFormField(
                        controller: _emailEditingController,
                        keyboardType: TextInputType.emailAddress,
                        //validate email
                        validator: (val) => val!.isEmpty ||
                                (!val.contains("@")) ||
                                (!val.contains("."))
                            ? "enter a valid email"
                            : null,
                        decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.mail),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0))),
                      ),
                      TextFormField(
                        controller: _passEditingController,
                        //validate password
                        validator: (val) => validatePassword(val.toString()),
                        obscureText: _passwordVisible1,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible1
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible1 = !_passwordVisible1;
                                });
                              },
                            ),
                            labelText: 'Password',
                            labelStyle: const TextStyle(),
                            icon: const Icon(Icons.lock),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0))),
                      ),
                      TextFormField(
                        controller: _pass2EditingController,
                        //checking if the password same of not
                        validator: (val) {
                          validatePassword(val.toString());
                          if (val != _passEditingController.text) {
                            return "Password do not match";
                          } else {
                            return null;
                          }
                        },
                        obscureText: _passwordVisible2,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible2
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible2 = !_passwordVisible2;
                                });
                              },
                            ),
                            labelText: 'Reenter Password',
                            labelStyle: const TextStyle(),
                            icon: const Icon(Icons.lock),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )),
              ElevatedButton(
                onPressed: () {
                  updateDialog();
                },
                child:
                    const Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty || value.length < 8) {
      return 'Please enter a password with at least 8 characters';
    } else if (!regex.hasMatch(value)) {
      return 'Contain at least A-Z, a-z, 0-9';
    }
    return null;
  }

  void updateProfile() {
    String name = _nameEditingController.text;
    String password = _passEditingController.text;
    http.post(Uri.parse("${MyConfig().SERVER}/barteritphp/php/update_user.php"),
        body: {
          "name": name,
          "email": widget.user.email,
          "password": password
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Success")));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => MainScreen(user: widget.user)),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Failed1")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Update Failed2")));
      }
    });
  }

  void updateDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please Enter the password or the username")));
      return;
    }
    updateProfile();
  }
}
