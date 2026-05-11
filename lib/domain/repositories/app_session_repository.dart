import 'package:flutter/material.dart';

import '../entities/app_settings.dart';
import '../entities/app_session.dart';

/// **AppSessionRepository** — Domain contract (interface).
///
/// This is the single source of truth for all app-wide lifecycle state.
/// Multiple Cubits (SettingsCubit, etc.) depend on this repository.
///
/// Architecture note:
/// The repository exposes a [settingsStream] so dependent Cubits react
/// reactively to changes without knowing how or where data is stored.
/// Swap the data layer (SQLite → Hive) without touching this interface.
abstract class AppSessionRepository {
  /// Reactive stream of current [AppSettings].
  /// All Cubits observing app-wide state subscribe here.
  Stream<AppSettings> get settingsStream;

  /// Load settings from local DB on app startup.
  Future<AppSettings> loadSettings();

  /// Persist theme choice and broadcast to [settingsStream].
  Future<void> saveTheme(ThemeMode themeMode);

  /// Persist locale choice and broadcast to [settingsStream].
  Future<void> saveLocale(Locale locale);

  /// Record session start time (called from SplashPage).
  Future<AppSession> saveOpenTime(DateTime time);

  /// Record session end time (called from lifecycle observer).
  Future<void> saveExitTime(DateTime time);
}
