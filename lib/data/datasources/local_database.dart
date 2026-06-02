// lib/data/datasources/local_database.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../core/constants/app_constants.dart';
import '../models/video_model.dart';

class LocalDatabase {
  static final LocalDatabase _instance = LocalDatabase._();
  static Database? _db;

  LocalDatabase._();
  factory LocalDatabase() => _instance;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.dbName);

    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.videosTable} (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        video_url TEXT NOT NULL,
        is_local_file INTEGER NOT NULL DEFAULT 0,
        username TEXT NOT NULL,
        caption TEXT NOT NULL,
        audio_name TEXT NOT NULL,
        category TEXT NOT NULL,
        accent_color INTEGER NOT NULL,
        likes_count INTEGER NOT NULL DEFAULT 0,
        comments_count INTEGER NOT NULL DEFAULT 0,
        shares_count INTEGER NOT NULL DEFAULT 0,
        is_liked INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL
      )
    ''');
  }

  // ── CRUD ─────────────────────────────────────────────────

  Future<List<VideoModel>> getAll() async {
    final db = await database;
    final rows = await db.query(
      AppConstants.videosTable,
      orderBy: 'created_at DESC',
    );
    return rows.map(VideoModel.fromMap).toList();
  }

  Future<VideoModel> insert(VideoModel model) async {
    final db = await database;
    await db.insert(
      AppConstants.videosTable,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return model;
  }

  Future<VideoModel> update(VideoModel model) async {
    final db = await database;
    await db.update(
      AppConstants.videosTable,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
    return model;
  }

  Future<void> delete(String id) async {
    final db = await database;
    await db.delete(
      AppConstants.videosTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> count() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as cnt FROM ${AppConstants.videosTable}',
    );
    return result.first['cnt'] as int;
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _db = null;
  }
}
