import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import '../newsmodel/newsmodel.dart';
import 'repository.dart';

class NewsDbProvider implements Source, Cache {
  Database db;
  NewsDbProvider() {
    init();
  }
  void init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'items.db');
    db = await openDatabase(path, version: 1,
        onCreate: (Database newdb, int version) {
      newdb.execute("""
      CREATE TABLE Items(
        id INTEGER PRIMARY KEY,
        deleted INTEGER,
        type TEXT,
        time INTEGER,
        by TEXT,
        text TEXT,
        dead INTEGER,
        parent INTEGER,
        kids BLOB,
        url TEXT,
        score INTEGER,
        title TEXT,
        descendants INTEGER
        )
        """);
    });
  }

  //store and fetcg top ids
  Future<List<int>> fetchTopIds() async {
    return null;
  }

  Future<NewsModel> fetchItem(int id) async {
    final maps = await db.query(
      'Items',
      columns: null,
      where: 'id=?',
      whereArgs: [id],
    );

    return maps.length > 0 ? NewsModel.fromDb(maps.first) : null;
  }

  Future<int> addItem(NewsModel item) {
    return db.insert(
      'Items',
      item.toMapfromDb(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int>  clear() {
    return db.delete('Items');
  }
}

final newsDbProvider = NewsDbProvider();
