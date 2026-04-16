import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../core/error/exceptions.dart';
import '../models/weather_forecast_model.dart';

abstract class WeatherLocalDataSource {
  Future<WeatherForecastModel> getLastSavedForecast();
  Future<void> cacheForecast(WeatherForecastModel forecastToCache);
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  static Database? _database;
  static const String tableName = 'weather_cache';

  Future<Database> get database async {
    if (_database != null) return _database!;
    final dbName = dotenv.env['DB_NAME'] ?? 'weather.db';
    _database = await _initDB(dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cached_data TEXT NOT NULL
      )
    ''');
  }

  @override
  Future<void> cacheForecast(WeatherForecastModel forecastToCache) async {
    final db = await database;
    try {
      // Clear old cache, keep only the latest one
      await db.delete(tableName);
      
      final jsonString = json.encode(forecastToCache.toJsonWrapper());
      await db.insert(tableName, {'cached_data': jsonString});
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<WeatherForecastModel> getLastSavedForecast() async {
    final db = await database;
    try {
      final maps = await db.query(tableName, orderBy: "id DESC", limit: 1);
      if (maps.isNotEmpty) {
        final jsonString = maps.first['cached_data'] as String;
        final jsonMap = json.decode(jsonString);
        return WeatherForecastModel.fromJsonWrapper(jsonMap);
      } else {
        throw CacheException();
      }
    } catch (e) {
      throw CacheException();
    }
  }
}
