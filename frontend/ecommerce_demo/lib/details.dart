import 'dart:convert';
import 'dart:ui';
import 'package:ecommerce_demo/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'service/cart_service.dart';
import 'providers/wishlist_provider.dart';
import 'service/wishlist_service.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  FlutterSecureStorage storage = FlutterSecureStorage();
  int number = 0;
  Map productData = {};
  late String userId;
  List userFavorites = [];

  void incrementNumber() {
    setState(() {
      number += 1;
    });
  }

  void decrementNumber() {
    setState(() {
      number -= 1;
    });
  }

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    productData = (ModalRoute.of(context)?.settings.arguments as Map?) ?? {};
    print(productData);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xffF1F0E9),
                  child: IconButton(
                    color: Color(0xff0D4715),
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context, {
                        "id": productData["id"],
                        "isFavorite": productData["isFavorite"],
                      });
                    },
                  ),
                ),
                Text(
                  "Product Details",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff0D4715),
                    fontFamily: "Poppins",
                    fontSize: 19.0,
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
            Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                child: Image.network(
                  "${productData["picture"]}",
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${productData["title"]}",
                    style: TextStyle(
                      color: Color(0xff0D4715),
                      fontFamily: "Poppins",
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Color(0xffF1F0E9),
                  child: IconButton(
                    color: Color(0xff0D4715),
                    onPressed: () {
                      Map data = {
                        "userId": userId,
                        "productId": productData["id"],
                      };
                      final isFav = productData["isFavorite"];
                      if (isFav) {
                        context.read<WishlistProvider>().removeFromFavorites(
                          data,
                          storage,
                        );
                      } else {
                        context.read<WishlistProvider>().addToFavorites(
                          data,
                          storage,
                        );
                      }
                      setState(() {
                        productData["isFavorite"] = !isFav;
                      });
                    },
                    icon: productData["isFavorite"]
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border_rounded),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 18, 0, 8),
                  child: Text(
                    "\$${productData["price"]}",
                    style: TextStyle(
                      color: Color(0xff0D4715),
                      fontFamily: "Poppins",
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(0xffF1F0E9),
                        child: IconButton(
                          color: Color(0xff0D4715),
                          onPressed: decrementNumber,
                          icon: Icon(Icons.remove),
                        ),
                      ),
                      Text(
                        "$number",
                        style: TextStyle(
                          color: Color(0xff0D4715),
                          fontFamily: "Poppins",
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Color(0xff0D4715),
                        child: IconButton(
                          onPressed: incrementNumber,
                          icon: Icon(Icons.add),
                          color: Color(0xffF1F0E9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.timer_sharp, color: Color(0xffE9762B)),
                      Text(
                        "Rapid",
                        style: TextStyle(
                          color: Color(0xff0D4715),
                          fontFamily: "Poppins",
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.insert_chart_outlined_rounded,
                        color: Color(0xff0D4715),
                      ),
                      Text(
                        "100+ bought",
                        style: TextStyle(
                          color: Color(0xff0D4715),
                          fontFamily: "Poppins",
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.star, color: Colors.yellow),
                      Text(
                        "4.5",
                        style: TextStyle(
                          color: Color(0xff0D4715),
                          fontFamily: "Poppins",
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: Color.fromARGB(255, 231, 229, 219), thickness: 0.8),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Description",
                style: TextStyle(
                  color: Color(0xff0D4715),
                  fontFamily: "Poppins",
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    color: Color(0xffF5F9F8),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "100% satisfaction guaranteed. Missing, poor items, poor quality or delivery issues? We'll resolve everything quickly, with care and professionalism.",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Color(0xff6B8A88),
                          fontFamily: "Poppins",
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
