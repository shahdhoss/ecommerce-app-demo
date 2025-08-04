import 'dart:convert';

import 'package:ecommerce_demo/cart_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "package:http/http.dart" as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({super.key});

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  FlutterSecureStorage storage = FlutterSecureStorage();
  List userCart = [];
  String userId = "";

  Future removeFromCart(Map data) async {
    String? token = await storage.read(key: 'token');
    final reponse = await http.delete(
      Uri.parse("http://10.0.2.2:8000/cart/remove"),
      headers: {"Content-Type": "application/json", "Authorization": "$token"},
      body: jsonEncode(data),
    );
    if (reponse.statusCode == 200) {
      print("removed from cart");
      return true;
    } else {
      print("Issues with adding to cart");
      return false;
    }
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

  void getUserCart(String userId) async {
    String? token = await storage.read(key: 'token');
    final reponse = await http.get(
      Uri.parse("http://10.0.2.2:8000/cart/get/${userId}"),
      headers: {"Content-Type": "application/json", "Authorization": "$token"},
    );
    if (reponse.statusCode == 200) {
      final decoded = jsonDecode(reponse.body);
      setState(() {
        userCart = decoded["cart"];
      });
    } else {
      print("Issues with getting user cart");
    }
  }

  void initialize() async {
    await setUserId();
    getUserCart(userId);
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 40, 15, 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Cart",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff0D4715),
                    fontFamily: "Poppins",
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Color(0xffF1F0E9),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.shopping_cart, color: Color(0xff0D4715)),
                  ),
                ),
              ],
            ),
            Expanded(
              child: userCart.length == 0
                  ? Center(
                      child: Text(
                        "Start adding items to your cart",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : userCart.isEmpty
                  ? Center(child: CupertinoActivityIndicator())
                  : ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 15);
                      },
                      itemCount: userCart.length,
                      itemBuilder: (context, index) {
                        void incrementQuantity() async {
                          Map data = {
                            "userId": userId,
                            "productId": userCart[index]["_id"],
                          };
                          if (await addToCart(data, storage)) {
                            setState(() {
                              userCart[index]["quantity"] =
                                  userCart[index]["quantity"] + 1;
                            });
                          }
                        }

                        void decrementQuantity() async {
                          Map data = {
                            "userId": userId,
                            "productId": userCart[index]["_id"],
                          };
                          if (await removeFromCart(data)) {
                            setState(() {
                              userCart[index]["quantity"] =
                                  userCart[index]["quantity"] - 1;
                            });
                          }
                        }

                        return Container(
                          decoration: BoxDecoration(color: Color(0xffF5F7F8)),
                          height: MediaQuery.of(context).size.height * 0.17,
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(7, 5, 10, 5),
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.27,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  child: Image.network(
                                    userCart[index]["picture"],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userCart[index]["title"],
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff0D4715),
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    Text(
                                      "1.5 lbs",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromARGB(
                                          255,
                                          126,
                                          126,
                                          126,
                                        ),
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                                child: Column(
                                  children: [
                                    IconButton(
                                      onPressed: incrementQuantity,
                                      icon: Icon(Icons.add, size: 20),
                                    ),
                                    Text(
                                      userCart[index]["quantity"].toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromARGB(255, 76, 76, 76),
                                        fontSize: 17.0,
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: decrementQuantity,
                                      icon: Icon(Icons.remove, size: 20),
                                    ),
                                  ],
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
