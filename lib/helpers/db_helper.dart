import 'package:bom_hamburguer/models/cart_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

import 'package:uuid/uuid.dart';

class DBHelper {
 static Database? _database;
 Uuid uuid =  const Uuid();

 Future<Database?> get database async {
   if (_database != null) {
     return _database!;
   }
   _database = await initDatabase();
   return _database;
 }

 Future<Database> initDatabase() async {
   io.Directory directory = await getApplicationDocumentsDirectory();
   String path = join(directory.path, 'cart.db');
   var db = await openDatabase(path, version: 1, onCreate: _onCreate);
   return db;
 }

 // creating database table
 _onCreate(Database db, int version) async {
   await db.execute('''
       CREATE TABLE cart(
        id TEXT PRIMARY KEY, 
        productId INTEGER , 
        productName TEXT, 
        initialPrice REAL, 
        productPrice REAL, 
        image TEXT,
        type TEXT
        )
      ''');
 }

 // inserting data into the table
 Future<Cart> insert(Cart cart) async {
  var dbClient = await database;
  cart.id = uuid.v4(); // generate a new unique ID
  await dbClient!.insert('cart', cart.toMap());
  return cart;
}

 // getting all the items in the list from the database
 Future<List<Cart>> getCartList() async {
   var dbClient = await database;
   final List<Map<String, Object?>> queryResult =
       await dbClient!.query('cart');
   return queryResult.map((result) => Cart.fromMap(result)).toList();
 }


 Future<List<Cart>> getCartListByType(String type) async {
   var dbClient = await database;
   final List<Map<String, Object?>> queryResult =
       await dbClient!.query('cart',where:'type = ?',whereArgs: [type]);
  

   return queryResult.map((result) => Cart.fromMap(result)).toList();
 }
 // deleting an item from the cart screen
 Future<int> deleteCartItem(String id) async {
   var dbClient = await database;
   return await dbClient!.delete('cart', where: 'id = ?', whereArgs: [id]);
 }
}
