import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import 'db_constants.dart';

class databaseConnection {
  static DbCollection? productCollection;
  static late Db db;
  
  static connect() async {
    try {
      db = await Db.create(connection_url);
      await db.open();
      inspect(db);
      productCollection = db.collection("products");
      print(productCollection);
    } catch (err) {
      print(err);
    }
  }

  static getData() async {
    final arrData = await productCollection!.find().toList();
    return arrData;
  }
}
