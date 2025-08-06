import 'package:ecommerce_demo/providers/user_provider.dart';
import 'package:ecommerce_demo/providers/wishlist_provider.dart';
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

  void initialize() async {
    userId = await context.read<UserProvider>().getUserId();
    userFavorites = await context.read<WishlistProvider>().getUserFavorites(
      userId,
    );
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
