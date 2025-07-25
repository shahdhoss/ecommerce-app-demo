import 'package:ecommerce_demo/products.dart';
import 'package:ecommerce_demo/profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List pages = [Products(), Profile()];
  int index = 0;
  void onTapped(int tappedIndex) {
    setState(() {
      index = tappedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.2,
        currentIndex: index,
        onTap: onTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.magnifyingGlass,
              color: Color(0xff0D4715),
            ),
            backgroundColor: Color(0xffF1F0E9),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_rounded, color: Color(0xff0D4715)),
            backgroundColor: Color(0xffF1F0E9),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
