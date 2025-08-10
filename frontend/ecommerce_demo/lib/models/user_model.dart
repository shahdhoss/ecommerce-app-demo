import "package:flutter/widgets.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:jwt_decoder/jwt_decoder.dart";

class UserProvider extends ChangeNotifier {
  FlutterSecureStorage storage = FlutterSecureStorage();
  String token = "";

  getUserId() {
    if (token == null || token.isEmpty) {
      return;
    }
    try {
      Map decodedToken = JwtDecoder.decode(token);
      String userId = decodedToken["userId"];
      notifyListeners();
      return userId;
    } catch (err) {
      print(err);
    }
  }

  bool isTokenExpired() {
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

  Future<void> loadUserToken() async {
    token = await storage.read(key: "token") ?? "";
    notifyListeners();
  }

  void setStorage(FlutterSecureStorage userStorage) {
    storage = userStorage;
  }
}
