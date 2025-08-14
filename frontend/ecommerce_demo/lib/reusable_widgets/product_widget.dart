import 'package:ecommerce_demo/models/wishlist_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class ProductPageWidget extends StatefulWidget {
  final List products;
  final FlutterSecureStorage storage;
  final String userId;
  final List userFavorites;
  final bool isLoaded;
  final bool tokenExpired;

  ProductPageWidget({
    super.key,
    required this.products,
    required this.storage,
    required this.userId,
    required this.userFavorites,
    required this.isLoaded,
    required this.tokenExpired
  });

  @override
  State<ProductPageWidget> createState() => _ProductPageWidgetState();
}

class _ProductPageWidgetState extends State<ProductPageWidget> {
  TextEditingController textEditingController = TextEditingController();

  bool isProductInFavorites(String productId) {
    for (var i = 0; i < widget.userFavorites.length; i++) {
      if (productId == widget.userFavorites[i]["_id"]) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 14, 0, 5.0),
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
              child: !widget.isLoaded
                  ? Center(child: CupertinoActivityIndicator())
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.78,
                          ),
                      itemCount: widget.products.length,
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
                                        onTap: () async {
                                          final result = await Navigator.pushNamed(
                                            context,
                                            '/details',
                                            arguments: {
                                              "id":
                                                  widget.products[index]["_id"],
                                              "title": widget
                                                  .products[index]["title"],
                                              "picture": widget
                                                  .products[index]["picture"],
                                              "price": widget
                                                  .products[index]["price"],
                                              "isFavorite": widget
                                                  .products[index]["isFavorite"],
                                              "description": widget
                                                  .products[index]["description"],
                                              "rating": widget
                                                  .products[index]["rating"],
                                            },
                                          );
                                          if (result != null && result is Map) {
                                            final productId = result["id"];
                                            final isFavorite =
                                                result["isFavorite"];
                                            setState(() {
                                              final i = widget.products
                                                  .indexWhere(
                                                    (p) =>
                                                        p["_id"] == productId,
                                                  );
                                              if (i != -1) {
                                                widget.products[i]["isFavorite"] =
                                                    isFavorite;
                                              }
                                            });
                                          }
                                        },
                                        child: Image.network(
                                          widget.products[index]["picture"],
                                          fit: BoxFit.cover,
                                          loadingBuilder:
                                              (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
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
                                  Positioned(
                                    top: 8,
                                    right: 5,
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
                                          if (!widget.tokenExpired) {
                                            Map data = {
                                              "userId": widget.userId,
                                              "productId":
                                                  widget.products[index]["_id"],
                                            };
                                            final isFav = isProductInFavorites(
                                              widget.products[index]["_id"],
                                            );
                                            if (isFav) {
                                              context
                                                  .read<WishlistProvider>()
                                                  .removeFromFavorites(
                                                    data,
                                                    widget.storage,
                                                  );
                                            } else {
                                              context
                                                  .read<WishlistProvider>()
                                                  .addToFavorites(
                                                    data,
                                                    widget.storage,
                                                  );
                                            }
                                            setState(() {
                                              widget.products[index]["isFavorite"] =
                                                  !isFav;
                                            });
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                backgroundColor:
                                                    Colors.red[700],
                                                content: Text(
                                                  "You have to be logged in first",
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
                                        icon: Icon(
                                          widget.products[index]["isFavorite"]
                                              ? Icons.favorite
                                              : Icons.favorite_border_outlined,
                                          color: Color(0xff0D4715),
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 3),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    widget.products[index]["title"].length > 15
                                        ? widget.products[index]["title"]
                                                  .substring(0, 15) +
                                              "..."
                                        : widget.products[index]["title"],
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
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "\$${widget.products[index]["price"].toString()}",
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
