import 'package:ecommerce_demo/pages/cart.dart';
import 'package:ecommerce_demo/pages/home.dart';
import 'package:ecommerce_demo/pages/login.dart';
import 'package:ecommerce_demo/pages/products.dart';
import 'package:ecommerce_demo/pages/wishlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../utils/token.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  final storage = FlutterSecureStorage();
  bool tokenExpiryState = true;
  List pages = [];
  int index = 0;
  bool isLoaded = false;

  void onTapped(int tappedIndex) {
    setState(() {
      index = tappedIndex;
    });
  }

  void checkTokenExpiry() async {
    try {
      tokenExpiryState = await isTokenExpired(storage);
      setState(() {
        if (tokenExpiryState) {
          pages = [Home(), Products(), Login()];
        } else {
          pages = [Home(), Products(), Wishlist(), CartWidget()];
        }
      });
    } catch (e) {
      print('Error during initialization: $e');
    } finally {
      if (mounted) {
        isLoaded = true;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkTokenExpiry();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: !isLoaded ? CupertinoActivityIndicator() : pages[index],
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
          tabs: tokenExpiryState
              ? [
                  GButton(icon: Icons.home, text: "Home"),
                  GButton(icon: Icons.search, text: "Browse"),
                  GButton(icon: Icons.person_2_rounded, text: "Login"),
                ]
              : [
                  GButton(icon: Icons.home, text: "Home"),
                  GButton(icon: Icons.search, text: "Browse"),
                  GButton(icon: Icons.favorite_border, text: "Wishlist"),
                  GButton(icon: Icons.shopping_cart, text: "Cart"),
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
