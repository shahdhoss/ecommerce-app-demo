import "dart:convert";

import "package:flutter/widgets.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:http/http.dart" as http;

class CartProvider extends ChangeNotifier {
  List userCart = [];
  FlutterSecureStorage storage = FlutterSecureStorage();

  Future getCart(String userId) async {
    String? token = await storage.read(key: 'token');
    final reponse = await http.get(
      Uri.parse("http://10.0.2.2:8000/cart/get/${userId}"),
      headers: {"Content-Type": "application/json", "Authorization": "$token"},
    );
    if (reponse.statusCode == 200) {
      final decoded = jsonDecode(reponse.body);
      userCart = decoded["cart"];
      return userCart;
    } else {
      print("Issues with setting the user favorites");
    }
  }

  Future addToCart(Map data, FlutterSecureStorage storage) async {
    String? token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse("http://10.0.2.2:8000/cart/add"),
      headers: {"Content-Type": "application/json", "Authorization": "$token"},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      userCart = decoded["userCart"];
      print("item added to cart");
      notifyListeners();
      return true;
    } else {
      print("Issues with adding to cart");
      return false;
    }
  }

  Future removeFromCart(Map data, FlutterSecureStorage storage) async {
    String? token = await storage.read(key: 'token');
    final response = await http.delete(
      Uri.parse("http://10.0.2.2:8000/cart/remove"),
      headers: {"Content-Type": "application/json", "Authorization": "$token"},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      userCart = decoded["userCart"];
      notifyListeners();
      return true;
    } else {
      print("Issues with adding to cart");
      return false;
    }
  }

  Future removeItemCompletely(Map data, FlutterSecureStorage storage) async {
    String? token = await storage.read(key: 'token');
    final response = await http.delete(
      Uri.parse("http://10.0.2.2:8000/cart/remove_completely"),
      headers: {"Content-Type": "application/json", "Authorization": "$token"},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      userCart = decoded["userCart"];
      notifyListeners();
      print("removed from cart");
      return true;
    } else {
      print("Issues with adding to cart");
      return false;
    }
  }
}
