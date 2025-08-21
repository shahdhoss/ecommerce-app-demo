import 'package:ecommerce_demo/models/user_model.dart';
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
import 'package:provider/provider.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  FlutterSecureStorage storage = FlutterSecureStorage();
  bool tokenExpired = true;
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
      await context.read<UserProvider>().loadUserToken();
      tokenExpired = context.read<UserProvider>().isTokenExpired();
      setState(() {
        if (tokenExpired) {
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
    tokenExpired = context.watch<UserProvider>().isTokenExpired();
    checkTokenExpiry();
    return Scaffold(
      body: !isLoaded ? CupertinoActivityIndicator() : pages[index],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Material(
            elevation: 10,
            shadowColor: Colors.black26,
            child: GNav(
              iconSize: 20,
              backgroundColor: Color(0xffE8F3EC),
              selectedIndex: index,
              color: Color(0xff0D4715),
              tabBackgroundColor: Colors.white70,
              tabBorderRadius: 20,
              activeColor: Colors.black,
              duration: Duration(milliseconds: 900),
              haptic: true,
              gap: 8,
              onTabChange: (indexInput) {
                setState(() {
                  index = indexInput;
                });
              },
              tabs: tokenExpired
                  ? [
                      GButton(icon: Icons.home),
                      GButton(icon: Icons.search),
                      GButton(icon: Icons.person_2_rounded),
                    ]
                  : [
                      GButton(icon: Icons.home),
                      GButton(icon: Icons.search),
                      GButton(icon: Icons.favorite_border),
                      GButton(icon: Icons.shopping_cart),
                    ],
            ),
          ),
        ),
      ),
    );
  }
}
