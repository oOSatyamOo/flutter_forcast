import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/app_settings_model.dart';
import 'app_local_data_source.dart';

/// **AppSqliteLocalDataSource** — Concrete sqflite implementation.
///
/// Implements [AppLocalDataSource] exclusively. All other layers depend
/// on the abstract contract, not this class. Swapping storage engines
/// requires only a new implementation + DI rebinding.
///
/// Tables:
///   - app_settings  (single-row settings: theme, locale)
///   - app_session   (lifecycle log: open_time, exit_time per session)
class AppSqliteLocalDataSource implements AppLocalDataSource {
  static Database? _db;

  Future<Database> get _database async {
    if (_db != null) return _db!;
    final dbName = dotenv.env['APP_DB_NAME'] ?? 'app_data.db';
    _db = await _initDB(dbName);
    return _db!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Single-row settings table (CHECK(id=1) enforces one row only)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS app_settings (
        id INTEGER PRIMARY KEY CHECK(id = 1),
        theme_mode TEXT NOT NULL DEFAULT 'system',
        locale_code TEXT NOT NULL DEFAULT 'en',
        updated_at TEXT NOT NULL
      )
    ''');

    // Session log: one row per app open/close lifecycle
    await db.execute('''
      CREATE TABLE IF NOT EXISTS app_session (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        open_time TEXT NOT NULL,
        exit_time TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Seed default settings row
    await db.insert('app_settings', {
      'id': 1,
      'theme_mode': 'system',
      'locale_code': 'en',
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<AppSettingsModel> loadSettings() async {
    final db = await _database;
    final rows = await db.query('app_settings', where: 'id = 1', limit: 1);
    if (rows.isNotEmpty) return AppSettingsModel.fromMap(rows.first);
    return const AppSettingsModel(
      themeMode: ThemeMode.system,
      locale: Locale('en'),
    );
  }

  @override
  Future<void> saveThemeMode(String themeMode) async {
    final db = await _database;
    await db.insert(
      'app_settings',
      {'id': 1, 'theme_mode': themeMode, 'locale_code': 'en', 'updated_at': DateTime.now().toIso8601String()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // Update only theme_mode, preserving locale
    await db.rawUpdate(
      'UPDATE app_settings SET theme_mode = ?, updated_at = ? WHERE id = 1',
      [themeMode, DateTime.now().toIso8601String()],
    );
  }

  @override
  Future<void> saveLocale(String localeCode) async {
    final db = await _database;
    await db.rawUpdate(
      'UPDATE app_settings SET locale_code = ?, updated_at = ? WHERE id = 1',
      [localeCode, DateTime.now().toIso8601String()],
    );
  }

  @override
  Future<int> saveOpenTime(DateTime openTime) async {
    final db = await _database;
    final now = DateTime.now().toIso8601String();
    return db.insert('app_session', {
      'open_time': openTime.toIso8601String(),
      'exit_time': null,
      'created_at': now,
    });
  }

  @override
  Future<void> saveExitTime(DateTime exitTime) async {
    final db = await _database;
    // Update only the most recent session row
    await db.rawUpdate(
      'UPDATE app_session SET exit_time = ? WHERE id = (SELECT MAX(id) FROM app_session)',
      [exitTime.toIso8601String()],
    );
  }
}
