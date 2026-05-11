import 'package:flutter/material.dart';
import '../../domain/entities/app_settings.dart';

/// **AppSettingsModel** — Data layer model.
/// Extends [AppSettings] (domain entity) and adds serialization methods
/// for the SQLite storage layer. Domain never imports this class.
class AppSettingsModel extends AppSettings {
  const AppSettingsModel({
    required super.themeMode,
    required super.locale,
  });

  factory AppSettingsModel.fromMap(Map<String, dynamic> map) {
    return AppSettingsModel(
      themeMode: _parseThemeMode(map['theme_mode'] as String? ?? 'system'),
      locale: Locale(map['locale_code'] as String? ?? 'en'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': 1, // Single-row constraint
      'theme_mode': _themeModeToString(themeMode),
      'locale_code': locale.languageCode,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  factory AppSettingsModel.fromEntity(AppSettings entity) {
    return AppSettingsModel(
      themeMode: entity.themeMode,
      locale: entity.locale,
    );
  }

  static ThemeMode _parseThemeMode(String value) {
    switch (value) {
      case 'light':  return ThemeMode.light;
      case 'dark':   return ThemeMode.dark;
      default:       return ThemeMode.system;
    }
  }

  static String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:  return 'light';
      case ThemeMode.dark:   return 'dark';
      case ThemeMode.system: return 'system';
    }
  }
}
