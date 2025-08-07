import 'package:ecommerce_demo/models/user_model.dart';
import 'package:ecommerce_demo/models/wishlist_model.dart';
import 'package:ecommerce_demo/utils/token.dart';
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
      userId = await context.read<UserProvider>().getUserId();
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
    if (tokenExpired) {
      userFavorites = context.watch<WishlistProvider>().userFavorites;
    }
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
              child: !isLoaded
                  ? Center(child: CupertinoActivityIndicator())
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.78,
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
                                        onTap: () async {
                                          final result = await Navigator.pushNamed(
                                            context,
                                            '/details',
                                            arguments: {
                                              "id": products[index]["_id"],
                                              "title": products[index]["title"],
                                              "picture":
                                                  products[index]["picture"],
                                              "price": products[index]["price"],
                                              "isFavorite":
                                                  products[index]["isFavorite"],
                                              "description":
                                                  products[index]["description"],
                                              "rating":
                                                  products[index]["rating"],
                                            },
                                          );
                                          if (result != null && result is Map) {
                                            final productId = result["id"];
                                            final isFavorite =
                                                result["isFavorite"];
                                            setState(() {
                                              final i = products.indexWhere(
                                                (p) => p["_id"] == productId,
                                              );
                                              if (i != -1) {
                                                products[i]["isFavorite"] =
                                                    isFavorite;
                                              }
                                            });
                                          }
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
                                          if (tokenExpired) {
                                            Map data = {
                                              "userId": userId,
                                              "productId":
                                                  products[index]["_id"],
                                            };
                                            final isFav = isProductInFavorites(
                                              products[index]["_id"],
                                            );
                                            if (isFav) {
                                              context
                                                  .read<WishlistProvider>()
                                                  .removeFromFavorites(
                                                    data,
                                                    storage,
                                                  );
                                            } else {
                                              context
                                                  .read<WishlistProvider>()
                                                  .addToFavorites(
                                                    data,
                                                    storage,
                                                  );
                                            }
                                            setState(() {
                                              products[index]["isFavorite"] =
                                                  !isFav;
                                            });
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                backgroundColor:
                                                    Colors.red[700],
                                                content: Text(
                                                  "You have to be logged in first",
                                                  style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
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
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 3),
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
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
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
