import 'package:ecommerce_demo/details.dart';
import 'package:ecommerce_demo/products.dart';
import 'package:ecommerce_demo/profile.dart';
import 'package:ecommerce_demo/signup.dart';
import 'package:ecommerce_demo/login.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'mongodb.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await databaseConnection.connect();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List pages = [Products(), Signup(), Login()];
  int index = 0;
  void onTapped(int tappedIndex) {
    setState(() {
      index = tappedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/details": (context) => ProductDetails(),
        "/search": (context) => Products(),
      },
      home: Scaffold(
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
              icon: Icon(
                Icons.signal_cellular_4_bar_outlined,
                color: Color(0xff0D4715),
              ),
              backgroundColor: Color(0xffF1F0E9),
              label: "Sign up",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_rounded, color: Color(0xff0D4715)),
              backgroundColor: Color(0xffF1F0E9),
              label: "login",
            ),
          ],
        ),
      ),
    );
  }
}
