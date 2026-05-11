import 'package:flutter/material.dart';
import 'package:skycast/core/error/failures.dart';
import 'package:skycast/domain/entities/app_settings.dart';
import 'package:skycast/domain/repositories/app_session_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Loads persisted [AppSettings] from local storage on app startup.
class LoadSettingsUseCase {
  final AppSessionRepository repository;
  LoadSettingsUseCase(this.repository);

  Future<Either<Failure, AppSettings>> call() async {
    try {
      final settings = await repository.loadSettings();
      return Right(settings);
    } catch (_) {
      return Right(AppSettings.defaultSettings);
    }
  }
}

/// Persists the user's chosen [ThemeMode].
class SaveThemeUseCase {
  final AppSessionRepository repository;
  SaveThemeUseCase(this.repository);

  Future<void> call(ThemeMode themeMode) => repository.saveTheme(themeMode);
}

/// Persists the user's chosen [Locale].
class SaveLocaleUseCase {
  final AppSessionRepository repository;
  SaveLocaleUseCase(this.repository);

  Future<void> call(Locale locale) => repository.saveLocale(locale);
}
