import 'package:ecommerce_demo/models/user_model.dart';
import 'package:ecommerce_demo/models/wishlist_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  final storage = FlutterSecureStorage();
  List userFavorites = [];
  String userId = '';
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();

  void initialize() async {
    try {
      await context.read<UserProvider>().loadUserToken();
      userId = await context.read<UserProvider>().getUserId();
      userFavorites = await context.read<WishlistProvider>().getUserFavorites(
        userId,
      );
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
    userFavorites = context.watch<WishlistProvider>().userFavorites;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 40, 15, 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
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
                      onPressed: () {
                        Navigator.pushNamed(context, "/cart");
                      },
                      icon: Icon(Icons.shopping_cart, color: Color(0xff0D4715)),
                    ),
                  ),
                ],
              ),
            ),
            CupertinoSearchTextField(
              controller: searchController,
              placeholder: 'Search Keywords...',
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CupertinoActivityIndicator())
                  : userFavorites.isEmpty
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
                  : ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 15);
                      },
                      itemCount: userFavorites.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            Map data = {
                              "userId": userId,
                              "productId": userFavorites[index]["_id"],
                            };
                            context
                                .read<WishlistProvider>()
                                .removeFromFavorites(data, storage);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xffEEF5F0),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            height: MediaQuery.of(context).size.height * 0.2,
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
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
                                                  Map data = {
                                                    "userId": userId,
                                                    "productId":
                                                        userFavorites[index]["_id"],
                                                  };
                                                  context
                                                      .read<WishlistProvider>()
                                                      .removeFromFavorites(
                                                        data,
                                                        storage,
                                                      );
                                                },
                                                icon: Icon(
                                                  Icons.favorite,
                                                  color: Color(0xff0D4715),
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        userFavorites[index]["description"]
                                                    .length <
                                                80
                                            ? userFavorites[index]["description"]
                                            : userFavorites[index]["description"]
                                                      .substring(0, 80) +
                                                  "...",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(
                                            255,
                                            126,
                                            126,
                                            126,
                                          ),
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      Text(
                                        "\$${userFavorites[index]["price"].toString()}",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff0D4715),
                                          fontSize: 15.0,
                                        ),
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
