// utils/db.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// ─── DEBUG FLAG ──────────────────────────────────────────────────────────────
const bool DEBUG = true; // ← toggle here

class DB {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'dengue_game.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
      onOpen: (db) async {
        if (DEBUG) {
          await _resetDatabase(db);
        }
      },
    );
  }

  // ─── RESET (DEBUG ONLY) ────────────────────────────────────────────────────
  static Future<void> _resetDatabase(Database db) async {
    await db.execute('DROP TABLE IF EXISTS player');
    await db.execute('DROP TABLE IF EXISTS progress');
    await db.execute('DROP TABLE IF EXISTS settings');

    await _createTables(db, 1);
  }

  // ─── CREATE TABLES ─────────────────────────────────────────────────────────
  static Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE player (
        id      INTEGER PRIMARY KEY,
        name    TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE progress (
        level       INTEGER PRIMARY KEY,
        correct     INTEGER NOT NULL DEFAULT 0,
        best_score  INTEGER NOT NULL DEFAULT 0,
        stars       INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE settings (
        id    INTEGER PRIMARY KEY,
        sound INTEGER NOT NULL DEFAULT 1
      )
    ''');

    await db.insert('settings', {'id': 1, 'sound': 1});
  }

  // ─── PLAYER ────────────────────────────────────────────────────────────────

  static Future<String?> getPlayerName() async {
    final db = await database;
    final rows = await db.query('player', limit: 1);
    if (rows.isEmpty) return null;
    return rows.first['name'] as String?;
  }

  static Future<void> savePlayerName(String name) async {
    final db = await database;
    await db.delete('player');
    await db.insert('player', {'name': name});
  }

  // ─── PROGRESS ──────────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>?> getProgress(int level) async {
    final db = await database;
    final rows = await db.query(
      'progress',
      where: 'level = ?',
      whereArgs: [level],
    );
    return rows.isEmpty ? null : rows.first;
  }

  static Future<void> saveProgress({
    required int level,
    required int correct,
    required int score,
    required int stars,
  }) async {
    final db = await database;
    final existing = await getProgress(level);

    if (existing == null) {
      await db.insert('progress', {
        'level': level,
        'correct': correct,
        'best_score': score,
        'stars': stars,
      });
    } else {
      if (score > (existing['best_score'] as int)) {
        await db.update(
          'progress',
          {'correct': correct, 'best_score': score, 'stars': stars},
          where: 'level = ?',
          whereArgs: [level],
        );
      }
    }
  }

  // ─── SETTINGS ──────────────────────────────────────────────────────────────

  static Future<bool> getSoundEnabled() async {
    final db = await database;
    final rows = await db.query('settings', where: 'id = 1');
    if (rows.isEmpty) return true;
    return (rows.first['sound'] as int) == 1;
  }

  static Future<void> setSoundEnabled(bool enabled) async {
    final db = await database;
    await db.update(
      'settings',
      {'sound': enabled ? 1 : 0},
      where: 'id = 1',
    );
  }
}