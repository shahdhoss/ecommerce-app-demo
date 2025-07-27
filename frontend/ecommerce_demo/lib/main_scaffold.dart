import 'package:ecommerce_demo/details.dart';
import 'package:ecommerce_demo/login.dart';
import 'package:ecommerce_demo/products.dart';
import 'package:ecommerce_demo/profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  List pages = [Products(), Login()];
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
            icon: Icon(FontAwesomeIcons.user, color: Color(0xff0D4715)),
            backgroundColor: Color(0xffF1F0E9),
            label: "Login",
          ),
        ],
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
