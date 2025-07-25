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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/details": (context) => ProductDetails(),
        "/": (context) => Signup(),
        "/login": (context) => Login(),
        "/signup": (context) => Signup(),
      },
    );
  }
}
