import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "package:http/http.dart" as http;
import 'dart:convert';
import "package:flutter/cupertino.dart";
import 'package:jwt_decoder/jwt_decoder.dart';
import "package:http/http.dart" as http;
import 'wishlist_functions.dart';

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

  void fetchProducts() async {
    final response = await http.get(
      Uri.parse("http://10.0.2.2:8000/products/get"),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map reponseProducts = jsonDecode(response.body);
      setState(() {
        products = reponseProducts["products"];
      });
      for (var i = 0; i < products.length; i++) {
        products[i]["isFavorite"] = false;
      }
    }
  }

  Future getUserFavorites(String userId) async {
    String? token = await storage.read(key: 'token');
    final reponse = await http.get(
      Uri.parse("http://10.0.2.2:8000/favorites/get/${userId}"),
      headers: {"Content-Type": "application/json", "Authorization": "$token"},
    );
    if (reponse.statusCode == 200) {
      final decoded = jsonDecode(reponse.body);
      userFavorites = decoded["products"];
      print("User favorites set successfully");
    } else {
      print("Issues with setting the user favorites");
    }
  }

  Future setUserFavorites() async {
    await getUserFavorites(userId);
    for (int i = 0; i < userFavorites.length; i++) {
      for (int j = 0; j < products.length; j++) {
        if (products[j]["_id"] == userFavorites[i]["productId"]) {
          products[j]["isFavorite"] = true;
        }
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  void updateUserFavorites() async {
    await getUserFavorites(userId);
    await setUserFavorites();
  }

  bool isProductInFavorites(String productId) {
    for (var i = 0; i < userFavorites.length; i++) {
      if (productId == userFavorites[i]["productId"]) {
        return true;
      }
    }
    return false;
  }

  Future setUserId() async {
    String? token = await storage.read(key: "token");
    if (token == null || token.isEmpty) {
      return;
    }
    try {
      Map decodedToken = JwtDecoder.decode(token);
      userId = decodedToken["userId"];
    } catch (err) {
      print(err);
    }
  }

  void initialize() async {
    await setUserId();
    await setUserFavorites();
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
    initialize();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 14, 0, 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Search",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0D4715),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CupertinoSearchTextField(
                controller: textEditingController,
                placeholder: 'Write here',
              ),
            ),
            Expanded(
              child: products.isEmpty
                  ? Center(child: CupertinoActivityIndicator())
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                          ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1.0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/details',
                                            arguments: {
                                              "title": products[index]["title"],
                                              "picture":
                                                  products[index]["picture"],
                                              "price": products[index]["price"],
                                            },
                                          );
                                        },
                                        child: Image.network(
                                          products[index]["picture"],
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value:
                                                    loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 5,
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Color.fromARGB(
                                        255,
                                        215,
                                        215,
                                        215,
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            products[index]["isFavorite"] =
                                                !products[index]["isFavorite"];
                                          });
                                          Map data = {
                                            "userId": userId,
                                            "productId": products[index]["_id"],
                                          };
                                          if (isProductInFavorites(
                                            products[index]["_id"],
                                          )) {
                                            removeFromFavorites(data, storage);
                                          } else {
                                            addToFavorites(data, storage);
                                          }
                                          updateUserFavorites();
                                        },
                                        icon: Icon(
                                          products[index]["isFavorite"]
                                              ? Icons.favorite
                                              : Icons.favorite_border_outlined,
                                          color: Color(0xff0D4715),
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    8,
                                    8,
                                    8,
                                    0,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      products[index]["title"].length > 15
                                          ? products[index]["title"].substring(
                                                  0,
                                                  15,
                                                ) +
                                                "..."
                                          : products[index]["title"],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff0D4715),
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  8.0,
                                  3,
                                  8,
                                  0,
                                ),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "\$${products[index]["price"].toString()}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff0D4715),
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
