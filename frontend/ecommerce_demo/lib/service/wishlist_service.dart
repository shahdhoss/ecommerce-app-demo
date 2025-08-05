import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "package:http/http.dart" as http;
import 'dart:convert';

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
    } else {
      print(response.statusCode);
    }
  } catch (err) {
    print("product failed to be removed from wishlist ${err}");
  }
}
