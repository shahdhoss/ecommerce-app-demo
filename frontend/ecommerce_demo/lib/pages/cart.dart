import 'package:ecommerce_demo/models/cart_model.dart';
import 'package:ecommerce_demo/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';

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
  double userCartTotal = 0.0;
  TextEditingController searchController = TextEditingController();
  final GlobalKey<SlideActionState> _key = GlobalKey<SlideActionState>();
  double delivery = 2.00;
  void initialize() async {
    try {
      await context.read<UserProvider>().loadUserToken();
      userId = await context.read<UserProvider>().getUserId();
      userCart = await context.read<CartProvider>().getCart(userId);
      userCartTotal = await context.read<CartProvider>().getUserTotal(
        userId,
        storage,
      );
      print(userCart);
      setState(() {});
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
    userCartTotal = context.watch<CartProvider>().userCartTotal;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 40, 15, 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
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
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: CupertinoSearchTextField(
                controller: searchController,
                placeholder: 'Search Keywords...',
              ),
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CupertinoActivityIndicator())
                  : userCart.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          "https://i.pinimg.com/originals/14/d5/06/14d5066da138b0f91f082f2ae60d6169.gif",
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress != null) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                              );
                            } else {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: child,
                              );
                            }
                          },
                        ),
                        Text(
                          "Empty basket",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff0D4715),
                          ),
                        ),
                        SizedBox(height: 10),
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
                        SizedBox(height: 10),
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
                  : Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 15);
                        },
                        itemCount: userCart.length + 1,
                        itemBuilder: (context, index) {
                          if (index == userCart.length) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(top: BorderSide()),
                                ),
                                width: MediaQuery.of(context).size.width * 1,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Subtotal",
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(
                                                255,
                                                102,
                                                102,
                                                102,
                                              ),
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          Text(
                                            "\$ ${userCartTotal.toStringAsFixed(2)}",
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(
                                                255,
                                                8,
                                                8,
                                                8,
                                              ),
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Delivery Fee",
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(
                                                255,
                                                102,
                                                102,
                                                102,
                                              ),
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          Text(
                                            "\$ ${delivery.toStringAsFixed(2)}",
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(
                                                255,
                                                8,
                                                8,
                                                8,
                                              ),
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ],
                                      ),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Total",
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(
                                                255,
                                                102,
                                                102,
                                                102,
                                              ),
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          Text(
                                            "\$ ${(delivery + userCartTotal).toStringAsFixed(2)}",
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(
                                                255,
                                                8,
                                                8,
                                                8,
                                              ),
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.6,
                                            child: SlideAction(
                                              height:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.06,
                                              sliderButtonIconSize: 15,
                                              sliderButtonIconPadding: 10,
                                              innerColor: Colors.white,
                                              outerColor: Color(0xff0D4715),
                                              text: "Go to Checkout",
                                              textStyle: TextStyle(
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                                color: Colors.white,
                                              ),
                                              key: _key,
                                              onSubmit: () {
                                                Future.delayed(
                                                  Duration(seconds: 1),
                                                  () => _key.currentState!
                                                      .reset(),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          return Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xffEEF5F0),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),

                                height:
                                    MediaQuery.of(context).size.height * 0.14,
                                width: MediaQuery.of(context).size.width * 1,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.fromLTRB(7, 5, 10, 5),
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.15,
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.35,
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
                                            MainAxisAlignment.center,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
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
                                                    await context
                                                        .read<CartProvider>()
                                                        .getUserTotal(
                                                          userId,
                                                          storage,
                                                        );
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
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
                                                  await context
                                                      .read<CartProvider>()
                                                      .getUserTotal(
                                                        userId,
                                                        storage,
                                                      );
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
                                                backgroundColor: Color(
                                                  0xff0D4715,
                                                ),
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
                                                print("im being pressed");
                                                Map data = {
                                                  "userId": userId,
                                                  "productId":
                                                      userCart[index]["_id"],
                                                };
                                                final success = await context
                                                    .read<CartProvider>()
                                                    .removeFromCart(
                                                      data,
                                                      storage,
                                                    );
                                                if (success) {
                                                  await context
                                                      .read<CartProvider>()
                                                      .getCart(userId);
                                                  await context
                                                      .read<CartProvider>()
                                                      .getUserTotal(
                                                        userId,
                                                        storage,
                                                      );
                                                  setState(() {});
                                                }
                                              },
                                              icon: CircleAvatar(
                                                radius: 15,
                                                backgroundColor: Color(
                                                  0xff0D4715,
                                                ),
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
                            ],
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
