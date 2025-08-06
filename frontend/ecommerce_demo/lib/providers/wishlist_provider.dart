import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class WishlistProvider extends ChangeNotifier {
  FlutterSecureStorage storage = FlutterSecureStorage();
  List userFavorites = [];

  void addToFavorites(Map data, FlutterSecureStorage storage) async {
    String? token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse("http://10.0.2.2:8000/favorites/add"),
      headers: {"Content-Type": "application/json", "Authorization": "$token"},
      body: jsonEncode(data),
    );
    try {
      if (response.statusCode == 200) {
        print("product liked");
        final decoded = jsonDecode(response.body);
        List newFavorites = decoded["userFavorites"];
        userFavorites = newFavorites;
        notifyListeners();
      } else {
        print(response.statusCode);
      }
    } catch (err) {
      print("product failed to be put into wishlist ${err}");
    }
  }

  void removeFromFavorites(Map data, FlutterSecureStorage storage) async {
    String? token = await storage.read(key: 'token');
    final response = await http.delete(
      Uri.parse("http://10.0.2.2:8000/favorites/remove"),
      headers: {"Content-Type": "application/json", "Authorization": "$token"},
      body: jsonEncode(data),
    );
    try {
      if (response.statusCode == 200) {
        print("product removed");
        final decoded = jsonDecode(response.body);
        List newFavorites = decoded["userFavorites"];
        userFavorites = newFavorites;
        notifyListeners();
      } else {
        print(response.statusCode);
      }
    } catch (err) {
      print("product failed to be removed from wishlist ${err}");
    }
  }

  Future getUserFavorites(String userId) async {
    String? token = await storage.read(key: 'token');
    final reponse = await http.get(
      Uri.parse("http://10.0.2.2:8000/favorites/get/${userId}"),
      headers: {"Content-Type": "application/json", "Authorization": "$token"},
    );
    if (reponse.statusCode == 200) {
      final decoded = jsonDecode(reponse.body);
      userFavorites = decoded["productDetails"];
      return userFavorites;
    } else {
      print("Issues with setting the user favorites");
    }
  }
}
