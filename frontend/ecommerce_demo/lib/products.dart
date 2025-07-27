import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'dart:convert';
import "package:flutter/cupertino.dart";
import 'mongodb.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List pictures = [];
  List titles = [];
  List prices = [];
  List favorites = [];
  TextEditingController textEditingController = TextEditingController();

  void fetchProducts() async {
    var products = await databaseConnection.getData();
    for (int i = 0; i < products.length; i++) {
      setState(() {
        titles.insert(i, products[i]["title"]);
        prices.insert(i, products[i]["price"]);
        pictures.insert(i, products[i]["picture"]);
        favorites.insert(i, false);
      });
    }
    print(prices);
    print(titles);
    print(pictures);
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Widget build(BuildContext context) {
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
              child: titles.isEmpty
                  ? Center(child: CupertinoActivityIndicator())
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                          ),
                      itemCount: titles.length,
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
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/details',
                                            arguments: {
                                              "title": titles[index],
                                              "picture": pictures[index],
                                              "price": prices[index],
                                            },
                                          );
                                        },
                                        child: Image.network(
                                          pictures[index],
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
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          favorites[index] = !favorites[index];
                                        });
                                      },
                                      icon: Icon(
                                        !favorites[index]
                                            ? Icons.favorite_border
                                            : Icons.favorite,
                                        color: Color(0xff0D4715),
                                      ),
                                    ),
                                  ),
                                ],
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
                                      titles[index].length > 15
                                          ? titles[index].substring(0, 15) +
                                                "..."
                                          : titles[index],
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
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  8.0,
                                  3,
                                  8,
                                  0,
                                ),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "\$${prices[index].toString()}",
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
