import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class ProductsModel extends ChangeNotifier {
  List products = [];

  Future fetchProducts() async {
    final response = await http.get(
      Uri.parse("http://10.0.2.2:8000/products/get"),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map reponseProducts = jsonDecode(response.body);
      products = reponseProducts["products"];
      return products;
    } else {
      print("problem with fetching products");
    }
  }
}
