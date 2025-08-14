import 'package:ecommerce_demo/models/user_model.dart';
import 'package:ecommerce_demo/models/wishlist_model.dart';
import 'package:ecommerce_demo/reusable_widgets/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "package:http/http.dart" as http;
import 'dart:convert';
import "package:flutter/cupertino.dart";
import 'package:provider/provider.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List products = [];
  List userFavorites = [];
  String userId = '';
  final storage = FlutterSecureStorage();
  TextEditingController textEditingController = TextEditingController();
  bool tokenExpired = true;
  bool isLoaded = false;

  Future fetchProducts() async {
    final response = await http.get(
      Uri.parse("http://10.0.2.2:8000/products/get"),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map reponseProducts = jsonDecode(response.body);
      print("products: ${reponseProducts["products"]}");
      setState(() {
        products = reponseProducts["products"];
        for (var i = 0; i < products.length; i++) {
          products[i]["isFavorite"] = isProductInFavorites(products[i]["_id"]);
        }
      });
    }
  }

  bool isProductInFavorites(String productId) {
    for (var i = 0; i < userFavorites.length; i++) {
      if (productId == userFavorites[i]["_id"]) {
        return true;
      }
    }
    return false;
  }

  void initialize() async {
    try {
      await context.read<UserProvider>().loadUserToken();
      userId = await context.read<UserProvider>().getUserId();
      tokenExpired = context.read<UserProvider>().isTokenExpired();
      if (!tokenExpired) {
        userFavorites = await context.read<WishlistProvider>().getUserFavorites(
          userId,
        );
      }
      await fetchProducts();
      setState(() {});
    } catch (e) {
      print('Error during initialization: $e');
    } finally {
      if (mounted) {
        isLoaded = true;
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Widget build(BuildContext context) {
    if (!tokenExpired) {
      userFavorites = context.watch<WishlistProvider>().userFavorites;
    }
    return ProductPageWidget(
      products: products,
      storage: storage,
      userId: userId,
      userFavorites: userFavorites,
      isLoaded: isLoaded,
      tokenExpired: tokenExpired,
    );
  }
}
