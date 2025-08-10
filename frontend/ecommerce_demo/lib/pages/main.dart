import 'package:ecommerce_demo/models/products_model.dart';
import 'package:ecommerce_demo/pages/cart.dart';
import 'package:ecommerce_demo/pages/chat.dart';
import 'package:ecommerce_demo/pages/details.dart';
import 'package:ecommerce_demo/pages/main_scaffold.dart';
import 'package:ecommerce_demo/pages/products.dart';
import 'package:ecommerce_demo/models/cart_model.dart';
import 'package:ecommerce_demo/models/user_model.dart';
import 'package:ecommerce_demo/models/wishlist_model.dart';
import 'package:ecommerce_demo/pages/signup.dart';
import 'package:ecommerce_demo/pages/login.dart';
import 'package:ecommerce_demo/pages/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';

const apiKey = "AIzaSyDLFaO7XWKnKa9yLHquEByr4YkmijCek9U";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => WishlistProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => ProductsModel()),
      ],
      child: MaterialApp(
        theme: ThemeData(scaffoldBackgroundColor: Colors.white),
        routes: {
          "/details": (context) => ProductDetails(),
          "/": (context) => MainScaffold(),
          "/login": (context) => Login(),
          "/signup": (context) => Signup(),
          "/chat": (context) => ChatWidget(),
          "/products": (context) => Products(),
          "/wishlist": (context)=> Wishlist(),
          "/cart": (context) => CartWidget()
        },
      ),
    );
  }
}
