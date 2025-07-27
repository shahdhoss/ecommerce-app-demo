import 'package:ecommerce_demo/chat.dart';
import 'package:ecommerce_demo/details.dart';
import 'package:ecommerce_demo/main_scaffold.dart';
import 'package:ecommerce_demo/products.dart';
import 'package:ecommerce_demo/signup.dart';
import 'package:ecommerce_demo/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'mongodb.dart';

const apiKey = "AIzaSyDLFaO7XWKnKa9yLHquEByr4YkmijCek9U";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await databaseConnection.connect();
  Gemini.init(apiKey: apiKey, enableDebugging: true);
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
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      routes: {
        "/details": (context) => ProductDetails(),
        "/": (context) => MainScaffold(),
        "/login": (context) => Login(),
        "/signup": (context) => Signup(),
        "/chat": (context) => ChatWidget(),
      },
    );
  }
}
