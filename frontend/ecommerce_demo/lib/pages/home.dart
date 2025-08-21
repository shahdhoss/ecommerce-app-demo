import 'dart:convert';

import 'package:ecommerce_demo/models/products_model.dart';
import 'package:ecommerce_demo/models/user_model.dart';
import 'package:ecommerce_demo/models/wishlist_model.dart';
import 'package:ecommerce_demo/reusable_widgets/category_icons.dart';
import 'package:ecommerce_demo/reusable_widgets/product_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List products = [];
  TextEditingController search = TextEditingController();
  final pageController = PageController();
  bool isLoaded = false;
  List userFavorites = [];
  String userId = '';
  final storage = FlutterSecureStorage();
  TextEditingController textEditingController = TextEditingController();
  bool tokenExpired = true;

  Future fetchByProductCategory(String category) async {
    final response = await http.get(
      Uri.parse("http://10.0.2.2:8000/products/get/${category}"),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map reponseProducts = jsonDecode(response.body);
      List chosenCategoryProducts = reponseProducts["products"];
      setState(() {
        products = reponseProducts["products"];
        for (var i = 0; i < products.length; i++) {
          products[i]["isFavorite"] = isProductInFavorites(products[i]["_id"]);
        }
      });
      return chosenCategoryProducts;
    } else {
      print("problem with fetching category products");
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
      setState(() {});
      products = await context.read<ProductsModel>().fetchProducts();
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
    products = context.watch<ProductsModel>().products;
    if (!tokenExpired) {
      userFavorites = context.watch<WishlistProvider>().userFavorites;
    }
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.32,
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: PageView(
                      controller: pageController,
                      children: [
                        Image(
                          fit: BoxFit.cover,
                          image: AssetImage("pictures/foodpic2.avif"),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress != null) {
                              return Center(
                                child: CupertinoActivityIndicator(),
                              );
                            } else {
                              return child;
                            }
                          },
                        ),
                        Image(
                          fit: BoxFit.cover,
                          image: AssetImage("pictures/foodpic1.avif"),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress != null) {
                              return Center(
                                child: CupertinoActivityIndicator(),
                              );
                            } else {
                              return child;
                            }
                          },
                        ),
                        Image(
                          fit: BoxFit.cover,
                          image: AssetImage("pictures/foodpic3.avif"),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress != null) {
                              return Center(
                                child: CupertinoActivityIndicator(),
                              );
                            } else {
                              return child;
                            }
                          },
                        ),
                        Image(
                          fit: BoxFit.cover,
                          image: AssetImage("pictures/foodpic4.avif"),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress != null) {
                              return Center(
                                child: CupertinoActivityIndicator(),
                              );
                            } else {
                              return child;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 20,
                    child: SmoothPageIndicator(
                      controller: pageController,
                      count: 4,
                      effect: WormEffect(
                        dotColor: Color(0xffF1F0E9),
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor: Color(0xff0D4715),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 17),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Categories",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0D4715),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CategoryIcons(
                    iconCategoryText: "Vegetables",
                    iconColor: Colors.green,
                    backgroundColor: Color(0xffF1F0E9),
                    icon: FontAwesomeIcons.leaf,
                    onPressed: () async {
                      var fruitProducts = await fetchByProductCategory(
                        "Vegetable",
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductPageWidget(
                            products: fruitProducts,
                            storage: storage,
                            userId: userId,
                            userFavorites: userFavorites,
                            isLoaded: isLoaded,
                            tokenExpired: tokenExpired,
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(26, 0, 0, 0),
                    child: CategoryIcons(
                      iconCategoryText: "Fruits",
                      iconColor: Colors.redAccent,
                      backgroundColor: Color.fromARGB(255, 255, 227, 214),
                      icon: FontAwesomeIcons.appleWhole,
                      onPressed: () async {
                        var fruitProducts = await fetchByProductCategory(
                          "Fruit",
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductPageWidget(
                              products: fruitProducts,
                              storage: storage,
                              userId: userId,
                              userFavorites: userFavorites,
                              isLoaded: isLoaded,
                              tokenExpired: tokenExpired,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(26, 0, 0, 0),
                    child: CategoryIcons(
                      iconCategoryText: "Beverages",
                      iconColor: Colors.orangeAccent,
                      backgroundColor: Color.fromARGB(255, 255, 238, 193),
                      icon: FontAwesomeIcons.mugHot,
                      onPressed: () async {
                        var fruitProducts = await fetchByProductCategory(
                          "Beverage",
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductPageWidget(
                              products: fruitProducts,
                              storage: storage,
                              userId: userId,
                              userFavorites: userFavorites,
                              isLoaded: isLoaded,
                              tokenExpired: tokenExpired,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(26, 0, 0, 0),
                    child: CategoryIcons(
                      iconCategoryText: "Grocery",
                      iconColor: const Color.fromARGB(255, 218, 98, 239),
                      backgroundColor: Color.fromARGB(255, 250, 208, 255),
                      icon: FontAwesomeIcons.breadSlice,
                      onPressed: () async {
                        var fruitProducts = await fetchByProductCategory(
                          "Grocery",
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductPageWidget(
                              products: fruitProducts,
                              storage: storage,
                              userId: userId,
                              userFavorites: userFavorites,
                              isLoaded: isLoaded,
                              tokenExpired: tokenExpired,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(26, 0, 0, 0),
                    child: CategoryIcons(
                      iconCategoryText: "Household",
                      iconColor: const Color.fromARGB(255, 245, 146, 179),
                      backgroundColor: Color.fromARGB(255, 255, 219, 234),
                      icon: FontAwesomeIcons.breadSlice,
                      onPressed: () async {
                        var fruitProducts = await fetchByProductCategory(
                          "Household",
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductPageWidget(
                              products: fruitProducts,
                              storage: storage,
                              userId: userId,
                              userFavorites: userFavorites,
                              isLoaded: isLoaded,
                              tokenExpired: tokenExpired,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(26, 0, 0, 0),
                    child: CategoryIcons(
                      iconCategoryText: "Babycare",
                      iconColor: Colors.lightBlue,
                      backgroundColor: Color.fromARGB(255, 201, 255, 254),
                      icon: FontAwesomeIcons.babyCarriage,
                      onPressed: () async {
                        var fruitProducts = await fetchByProductCategory(
                          "Babycare",
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductPageWidget(
                              products: fruitProducts,
                              storage: storage,
                              userId: userId,
                              userFavorites: userFavorites,
                              isLoaded: isLoaded,
                              tokenExpired: tokenExpired,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 16),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Featured products",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0D4715),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.keyboard_arrow_right_rounded, size: 30),
                ),
              ],
            ),
            Expanded(
              child: !isLoaded
                  ? Center(child: CupertinoActivityIndicator())
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 16, 8),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 60,
                            child: Column(
                              children: [
                                AspectRatio(
                                  aspectRatio: 1.645,
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
                                            "id": products[index]["_id"],
                                            "title": products[index]["title"],
                                            "picture":
                                                products[index]["picture"],
                                            "price": products[index]["price"],
                                            "isFavorite":
                                                products[index]["isFavorite"],
                                            "description":
                                                products[index]["description"],
                                            "rating": products[index]["rating"],
                                          },
                                        );
                                      },
                                      child: Image.network(
                                        products[index]["picture"],
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Center(
                                                child:
                                                    CupertinoActivityIndicator(),
                                              );
                                            },
                                      ),
                                    ),
                                  ),
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
                                            ? products[index]["title"]
                                                      .substring(0, 15) +
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/chat");
        },
        child: Icon(FontAwesomeIcons.message, color: Color(0xff0D4715)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
