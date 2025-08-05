import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'service/wishlist_service.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  final storage = FlutterSecureStorage();
  List userFavorites = [];
  String userId = '';
  List quantites = [];

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

  Future getUserFavorites(String userId) async {
    String? token = await storage.read(key: 'token');
    final reponse = await http.get(
      Uri.parse("http://10.0.2.2:8000/favorites/get/details/${userId}"),
      headers: {"Content-Type": "application/json", "Authorization": "$token"},
    );
    if (reponse.statusCode == 200) {
      final decoded = jsonDecode(reponse.body);
      setState(() {
        userFavorites = decoded["productDetails"];
        quantites = List.filled(userFavorites.length, 0);
      });
      print("favorites: ${userFavorites} ");
      print("User favorites set successfully");
    } else {
      print("Issues with setting the user favorites");
    }
  }

  void initialize() async {
    await setUserId();
    await getUserFavorites(userId);
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
                  "Wishlist",
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
              child: userFavorites.length == 0
                  ? Center(
                      child: Text(
                        "Start saving your favorite items",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : userFavorites.isEmpty
                  ? Center(child: CupertinoActivityIndicator())
                  : ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 15);
                      },
                      itemCount: userFavorites.length,
                      itemBuilder: (context, index) {
                        void incrementQuantity() {
                          setState(() {
                            quantites[index]++;
                          });
                        }

                        void decrementQuantity() {
                          if (quantites[index] > 0) {
                            setState(() {
                              quantites[index]--;
                            });
                          }
                        }

                        return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            Map data = {
                              "userId": userId,
                              "productId": userFavorites[index]["_id"],
                            };
                            removeFromFavorites(data, storage);
                          },
                          child: Container(
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.27,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    child: Image.network(
                                      userFavorites[index]["picture"],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userFavorites[index]["title"],
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
                                  padding: const EdgeInsets.fromLTRB(
                                    0,
                                    0,
                                    3,
                                    0,
                                  ),
                                  child: Column(
                                    children: [
                                      IconButton(
                                        onPressed: incrementQuantity,
                                        icon: Icon(Icons.add, size: 20),
                                      ),
                                      Text(
                                        quantites[index].toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(
                                            255,
                                            76,
                                            76,
                                            76,
                                          ),
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
