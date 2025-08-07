import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

Future isTokenExpired(FlutterSecureStorage storage) async {
    String? token = await storage.read(key: "token");
    if (token == null || token.isEmpty) {
      return true;
    }
    try {
      Map decodedToken = JwtDecoder.decode(token);
      DateTime expirationDate = JwtDecoder.getExpirationDate(token);
      return expirationDate.isBefore(DateTime.now());
    } catch (err) {
      print(err);
      return true;
    }
  }