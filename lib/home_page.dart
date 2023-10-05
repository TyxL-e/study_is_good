import 'package:flutter/material.dart';
import 'package:study_is_good/home_screen.dart';
import 'package:study_is_good/profile_page.dart';
import 'package:study_is_good/session_screen.dart';
import 'package:study_is_good/shop_page.dart';
import 'package:study_is_good/test_everything_screen.dart';

class BottomNavigationBarControl extends StatefulWidget {
  const BottomNavigationBarControl({super.key});

  @override
  State<BottomNavigationBarControl> createState() =>
      _BottomNavigationBarControlState();
}

class _BottomNavigationBarControlState
    extends State<BottomNavigationBarControl> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const ShopPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_business_outlined),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.sensors_sharp),
          //   label: 'Session',
          // ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

