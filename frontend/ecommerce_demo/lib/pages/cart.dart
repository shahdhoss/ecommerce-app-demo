import 'package:ecommerce_demo/models/cart_model.dart';
import 'package:ecommerce_demo/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import "../utils/token.dart";

class CartWidget extends StatefulWidget {
  const CartWidget({super.key});

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  FlutterSecureStorage storage = FlutterSecureStorage();
  List userCart = [];
  String userId = "";
  bool tokenExpired = false;
  bool isLoading = true;

  void initialize() async {
    try {
      userId = await context.read<UserProvider>().getUserId();
      tokenExpired = await isTokenExpired(storage);
      if (!tokenExpired) {
        userCart = await context.read<CartProvider>().getCart(userId);
        print(userCart);
      }
    } catch (e) {
      print('Error during initialization: $e');
      tokenExpired = true;
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    if (!tokenExpired) {
      userCart = context.watch<CartProvider>().userCart;
    }
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
              child: isLoading
                  ? Center(child: CupertinoActivityIndicator())
                  : userCart.isEmpty
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
                  : tokenExpired
                  ? Text(
                      "Login to start seeing your cart items",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 15);
                      },
                      itemCount: userCart.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) async {
                            Map data = {
                              "userId": userId,
                              "productId": userCart[index]["_id"],
                            };

                            bool success = await context
                                .read<CartProvider>()
                                .removeItemCompletely(data, storage);
                            if (success) {
                              setState(() {});
                            }
                          },
                          direction: DismissDirection.endToStart,
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
                                      userCart[index]["picture"],
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
                                  padding: const EdgeInsets.fromLTRB(
                                    0,
                                    0,
                                    3,
                                    0,
                                  ),
                                  child: Column(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          Map data = {
                                            "userId": userId,
                                            "productId": userCart[index]["_id"],
                                          };

                                          final success = await context
                                              .read<CartProvider>()
                                              .addToCart(data, storage);
                                          if (success) {
                                            await context
                                                .read<CartProvider>()
                                                .getCart(userId);
                                            setState(() {});
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                backgroundColor:
                                                    Colors.red[700],
                                                content: Text(
                                                  "Product out of stock",
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

                                        icon: Icon(Icons.add, size: 20),
                                      ),
                                      Text(
                                        userCart[index]["quantity"].toString(),
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
                                        onPressed: () async {
                                          Map data = {
                                            "userId": userId,
                                            "productId": userCart[index]["_id"],
                                          };
                                          final success = await context
                                              .read<CartProvider>()
                                              .removeFromCart(data, storage);
                                          if (success) {
                                            await context
                                                .read<CartProvider>()
                                                .getCart(userId);
                                            setState(() {});
                                          }
                                        },
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
