import 'package:ecommerce_demo/models/cart_model.dart';
import 'package:ecommerce_demo/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({super.key});

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  FlutterSecureStorage storage = FlutterSecureStorage();
  List userCart = [];
  String userId = "";
  bool isLoading = true;

  void initialize() async {
    try {
      await context.read<UserProvider>().loadUserToken();
      userId = await context.read<UserProvider>().getUserId();
      userCart = await context.read<CartProvider>().getCart(userId);
      print(userCart);
    } catch (e) {
      print('Error during initialization: $e');
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
    userCart = context.watch<CartProvider>().userCart;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 40, 15, 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xffF1F0E9),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, color: Color(0xff0D4715)),
                  ),
                ),
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
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.network(
                          "https://i.pinimg.com/736x/8d/49/0d/8d490d9ad19b49090945acd7cf7895d9.jpg",
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width * 0.9,
                        ),
                        Text(
                          "Empty basket",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff0D4715),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                          child: Center(
                            child: Text(
                              "Some of the things you like are on \n your Wishlist, don't miss out!",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff0D4715),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/wishlist");
                          },
                          child: Text(
                            "Check your wishlist",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                        ),
                      ],
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
                            decoration: BoxDecoration(
                              color: Color(0xffF5F7F8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),

                            height: MediaQuery.of(context).size.height * 0.17,
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                        "\$${userCart[index]["price"]}",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff0D4715),
                                          fontSize: 17.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            0,
                                            3,
                                            1,
                                            0,
                                          ),
                                          child: IconButton(
                                            onPressed: () async {
                                              Map data = {
                                                "userId": userId,
                                                "productId":
                                                    userCart[index]["_id"],
                                              };

                                              bool success = await context
                                                  .read<CartProvider>()
                                                  .removeItemCompletely(
                                                    data,
                                                    storage,
                                                  );
                                              if (success) {
                                                setState(() {});
                                              }
                                            },
                                            icon: Icon(
                                              FontAwesomeIcons.xmark,
                                              color: Colors.grey,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            Map data = {
                                              "userId": userId,
                                              "productId":
                                                  userCart[index]["_id"],
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
                                          icon: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Color(0xff0D4715),
                                            child: Icon(
                                              Icons.add,
                                              size: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          userCart[index]["quantity"]
                                              .toString(),
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
                                              "productId":
                                                  userCart[index]["_id"],
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
                                          icon: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Color(0xff0D4715),
                                            child: Icon(
                                              Icons.remove,
                                              size: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
