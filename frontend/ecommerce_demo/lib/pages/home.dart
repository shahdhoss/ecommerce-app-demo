import 'package:ecommerce_demo/models/products_model.dart';
import 'package:ecommerce_demo/pages/details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import "package:http/http.dart" as http;
import 'dart:convert';

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

  void initialize() async {
    products = await context.read<ProductsModel>().fetchProducts();
    if (mounted) {
      isLoaded = true;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Widget build(BuildContext context) {
    products = context.watch<ProductsModel>().products;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
        child: Column(
          children: [
            CupertinoSearchTextField(
              controller: search,
              placeholder: 'Search Keywords...',
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: PageView(
                      controller: pageController,
                      children: [
                        Image(
                          fit: BoxFit.cover,
                          image: AssetImage("pictures/foodpic1.avif"),
                        ),
                        Image(
                          fit: BoxFit.cover,
                          image: AssetImage("pictures/foodpic2.avif"),
                        ),
                        Image(
                          fit: BoxFit.cover,
                          image: AssetImage("pictures/foodpic3.avif"),
                        ),
                        Image(
                          fit: BoxFit.cover,
                          image: AssetImage("pictures/foodpic4.avif"),
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
                      effect: ExpandingDotsEffect(
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
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Color(0xffF1F0E9),
                        child: IconButton(
                          alignment: Alignment.center,
                          iconSize: 28,
                          onPressed: () {},
                          icon: Icon(
                            FontAwesomeIcons.leaf,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Vegetables",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff6B8A88),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(26, 0, 0, 0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Color.fromARGB(255, 255, 227, 214),
                          child: IconButton(
                            alignment: Alignment.center,
                            iconSize: 28,
                            onPressed: () {},
                            icon: Icon(
                              FontAwesomeIcons.appleWhole,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Fruits",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff6B8A88),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(26, 0, 0, 0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Color.fromARGB(255, 255, 238, 193),
                          child: IconButton(
                            alignment: Alignment.center,
                            iconSize: 28,
                            onPressed: () {},
                            icon: Icon(
                              FontAwesomeIcons.mugHot,
                              color: Colors.orangeAccent,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Beverages",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff6B8A88),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(26, 0, 0, 0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Color.fromARGB(255, 250, 208, 255),
                          child: IconButton(
                            alignment: Alignment.center,
                            iconSize: 28,
                            onPressed: () {},
                            icon: Icon(
                              FontAwesomeIcons.breadSlice,
                              color: const Color.fromARGB(255, 218, 98, 239),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Grocery",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff6B8A88),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(26, 0, 0, 0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Color.fromARGB(255, 255, 219, 234),
                          child: IconButton(
                            alignment: Alignment.center,
                            iconSize: 28,
                            onPressed: () {},
                            icon: Icon(
                              FontAwesomeIcons.bath,
                              color: const Color.fromARGB(255, 245, 146, 179),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Household",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff6B8A88),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(26, 0, 0, 0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Color.fromARGB(255, 201, 255, 254),
                          child: IconButton(
                            alignment: Alignment.center,
                            iconSize: 28,
                            onPressed: () {},
                            icon: Icon(
                              FontAwesomeIcons.babyCarriage,
                              color: Colors.lightBlue,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Babycare",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff6B8A88),
                          ),
                        ),
                      ],
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
                  onPressed: () {
                    Navigator.pushNamed(context, "/products");
                  },
                  icon: Icon(Icons.keyboard_arrow_right_rounded, size: 30),
                ),
              ],
            ),
            Expanded(
              child: !isLoaded
                  ? Center(child:  CupertinoActivityIndicator())
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 16, 8),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 60,
                            child: Column(
                              children: [
                                AspectRatio(
                                  aspectRatio: 1.47,
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
                                            "title": products[index]["title"],
                                            "picture":
                                                products[index]["picture"],
                                            "price": products[index]["price"],
                                          },
                                        );
                                      },
                                      child: Image.network(
                                        products[index]["picture"],
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
    );
  }
}
