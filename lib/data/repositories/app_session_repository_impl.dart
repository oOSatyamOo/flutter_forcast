import 'dart:async';

import 'package:flutter/material.dart';

import '../../domain/entities/app_session.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/app_session_repository.dart';
import '../datasources/app_local_data_source.dart';
import '../models/app_session_model.dart';

/// **AppSessionRepositoryImpl** — Bridges the data and domain layers.
///
/// Holds the in-memory [StreamController] that broadcasts [AppSettings]
/// changes to all subscribed Cubits. Because this is registered as a
/// LazySingleton in the DI container, the stream lives for the full
/// app session — enabling many-to-many ViewModel ↔ Repository reactivity.
class AppSessionRepositoryImpl implements AppSessionRepository {
  final AppLocalDataSource localDataSource;

  /// Broadcast stream so multiple Cubits can listen simultaneously.
  final _settingsController = StreamController<AppSettings>.broadcast();

  AppSessionRepositoryImpl({required this.localDataSource});

  @override
  Stream<AppSettings> get settingsStream => _settingsController.stream;

  @override
  Future<AppSettings> loadSettings() async {
    final model = await localDataSource.loadSettings();
    // Emit initial state so all current listeners receive it.
    _settingsController.add(model);
    return model;
  }

  @override
  Future<void> saveTheme(ThemeMode themeMode) async {
    final current = await localDataSource.loadSettings();
    await localDataSource.saveThemeMode(_themeModeToString(themeMode));
    // Broadcast the updated settings to all Cubits.
    _settingsController.add(current.copyWith(themeMode: themeMode));
  }

  @override
  Future<void> saveLocale(Locale locale) async {
    final current = await localDataSource.loadSettings();
    await localDataSource.saveLocale(locale.languageCode);
    _settingsController.add(current.copyWith(locale: locale));
  }

  @override
  Future<AppSession> saveOpenTime(DateTime time) async {
    final id = await localDataSource.saveOpenTime(time);
    return AppSessionModel(id: id, openTime: time, createdAt: time);
  }

  @override
  Future<void> saveExitTime(DateTime time) async {
    await localDataSource.saveExitTime(time);
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  void dispose() => _settingsController.close();
}
