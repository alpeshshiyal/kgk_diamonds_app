// Database Helper for Cart Persistence
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/diamond.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cart.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE cart(lotId TEXT PRIMARY KEY, size TEXT, carat REAL, lab TEXT, shape TEXT, color TEXT, clarity TEXT, cut TEXT, polish TEXT, symmetry TEXT, fluorescence TEXT, discount REAL, perCaratRate REAL, finalAmount REAL)"
        );
      },
    );
  }

  Future<void> insertDiamond(Diamond diamond) async {
    final db = await database;
    await db.insert('cart', diamond.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeDiamond(String lotId) async {
    final db = await database;
    await db.delete('cart', where: 'lotId = ?', whereArgs: [lotId]);
  }

  Future<List<Diamond>> getCartItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cart');
    debugPrint("get local cart data:${maps}");
    return maps.map((element)=>Diamond.fromJsonLocal(element)).toList();
  }
}