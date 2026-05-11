import '../models/app_settings_model.dart';

/// **AppLocalDataSource** — Abstract storage contract.
///
/// This abstraction is the key to storage-agnosticism.
/// The domain and presentation layers NEVER import sqflite directly.
/// To swap sqflite → Hive/Isar/ObjectBox:
///   1. Write a new class implementing this interface.
///   2. Update the DI binding. That's it — zero changes elsewhere.
abstract class AppLocalDataSource {
  /// Load settings from local storage. Returns defaults if not found.
  Future<AppSettingsModel> loadSettings();

  /// Persist theme mode string (e.g., 'light', 'dark', 'system').
  Future<void> saveThemeMode(String themeMode);

  /// Persist locale code (e.g., 'en', 'hi', 'ta', 'ru', 'ja').
  Future<void> saveLocale(String localeCode);

  /// Insert a new session row with [openTime]. Returns the new session ID.
  Future<int> saveOpenTime(DateTime openTime);

  /// Update the latest session row's exit_time.
  Future<void> saveExitTime(DateTime exitTime);
}
