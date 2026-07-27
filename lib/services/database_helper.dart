import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import '../models/joke.dart';
import '../models/joke_category.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('jokes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    String path;
    if (kIsWeb) {
      path = filePath;
    } else {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      path = join(documentsDirectory.path, filePath);
    }

    if (!await databaseFactory.databaseExists(path)) {
      ByteData data = await rootBundle.load('assets/$filePath');
      Uint8List bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await databaseFactory.writeDatabaseBytes(path, bytes);
    }

    return await openDatabase(path);
  }

  Future<List<JokeCategory>> getCategories() async {
    final db = await instance.database;
    final result = await db.query('categories');
    return result.map((json) => JokeCategory.fromMap(json)).toList();
  }

  Future<List<Joke>> getJokesByCategory(int categoryId) async {
    final db = await instance.database;
    final result = await db.query(
      'jokes',
      where: 'categoryID = ?',
      whereArgs: [categoryId],
    );
    return result.map((json) => Joke.fromMap(json)).toList();
  }

  Future<List<Joke>> getFavoriteJokes() async {
    final db = await instance.database;
    final result = await db.query(
      'jokes',
      where: 'favourite = ?',
      whereArgs: [1],
    );
    return result.map((json) => Joke.fromMap(json)).toList();
  }

  Future<List<Joke>> searchJokes(String query) async {
    final db = await instance.database;
    final result = await db.query(
      'jokes',
      where: 'content LIKE ?',
      whereArgs: ['%$query%'],
    );
    return result.map((json) => Joke.fromMap(json)).toList();
  }

  Future<void> toggleFavorite(int jokeId, bool isFavorite) async {
    final db = await instance.database;
    await db.update(
      'jokes',
      {'favourite': isFavorite ? 1 : 0},
      where: '_id = ?',
      whereArgs: [jokeId],
    );
  }

  Future<void> removeAllFavorites() async {
    final db = await instance.database;
    await db.update(
      'jokes',
      {'favourite': 0},
    );
  }

  Future<int> getTotalJokesCount() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM jokes');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
