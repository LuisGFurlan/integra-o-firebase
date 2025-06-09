import 'dart:async';
import 'package:firebase_app/photo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() => _instance;

  DBHelper._internal();

  static Database? _db;

  final String TABLE = 'PhotosTable';
  final String ID = 'id';
  final String UID = 'uid';
  final String NAME = 'photo_name';

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'photos.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $TABLE (
        $ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $UID TEXT,
        $NAME TEXT
      )
    ''');
  }

  Future<int> save(Photo photo) async {
    var dbClient = await db;

    // Opcional: Remover fotos antigas do mesmo usuário (mantém só a última)
    await dbClient.delete(TABLE, where: '$UID = ?', whereArgs: [photo.uid]);

    return await dbClient.insert(TABLE, photo.toMap());
  }

  Future<List<Photo>> getPhotosByUid(String uid) async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query(
      TABLE,
      columns: [ID, UID, NAME],
      where: '$UID = ?',
      whereArgs: [uid],
    );
    return maps.map((map) => Photo.fromMap(map)).toList();
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(Photo photo) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, photo.toMap(),
        where: '$ID = ?', whereArgs: [photo.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
