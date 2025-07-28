import 'package:ecommerce_demo/details.dart';
import 'package:ecommerce_demo/home.dart';
import 'package:ecommerce_demo/login.dart';
import 'package:ecommerce_demo/products.dart';
import 'package:ecommerce_demo/profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  List pages = [Home(), Products(), Login()];
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
      bottomNavigationBar: SizedBox(
        height: 70,
        child: GNav(
          iconSize: 20,
          backgroundColor: Colors.white,
          selectedIndex: index,
          color: Colors.grey,
          tabBackgroundColor: Color(0xFFF7F7F7),
          activeColor: Colors.black,
          duration: Duration(milliseconds: 900),
          haptic: true,
          gap: 8,
          onTabChange: (indexInput) {
            setState(() {
              index = indexInput;
            });
          },
          tabs: [
            GButton(icon: Icons.home, text: "Home"),
            GButton(icon: Icons.search, text: "Search"),
            GButton(icon: Icons.person_2_rounded, text: "Login"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/chat");
        },
        child: Icon(FontAwesomeIcons.message, color: Color(0xff0D4715)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
