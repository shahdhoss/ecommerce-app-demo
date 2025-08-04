import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<bool> addToCart(Map data, FlutterSecureStorage storage) async {
  String? token = await storage.read(key: 'token');
  final response = await http.post(
    Uri.parse("http://10.0.2.2:8000/cart/add"),
    headers: {"Content-Type": "application/json", "Authorization": "$token"},
    body: jsonEncode(data),
  );
  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    return true;
  } else {
    print("Issues with adding to cart");
    return false;
  }
}
