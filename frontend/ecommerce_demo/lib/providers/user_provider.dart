import "package:flutter/widgets.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:jwt_decoder/jwt_decoder.dart";

class UserProvider extends ChangeNotifier {
  FlutterSecureStorage storage = FlutterSecureStorage();

  Future getUserId() async {
    String? token = await storage.read(key: "token");
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
}
