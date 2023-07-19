import 'package:barterit/models/user.dart';
import 'package:barterit/views/seller/myitemstab.dart';
import 'package:barterit/views/barter/bartertab.dart';
import 'package:barterit/views/chatstab.dart';
import 'package:barterit/views/profile/profiletab.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String maintitle = "Barter";
  late List<Widget> tabchildren;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    tabchildren = [
      BarterTab(
        user: widget.user,
      ),
      MyItemsTab(user: widget.user),
      const ChatsTab(),
      ProfileTab(user: widget.user),
    ];
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.currency_exchange,
              ),
              label: "Barter"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_business,
              ),
              label: "My Item"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.chat,
              ),
              label: "Chat"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: "Profile")
        ],
      ),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "Barter";
      }
      if (_currentIndex == 1) {
        maintitle = "My Item";
      }
      if (_currentIndex == 2) {
        maintitle = "Chat";
      }
      if (_currentIndex == 3) {
        maintitle = "Profile";
      }
    });
  }
}
