import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/app_session_repository.dart';
import '../../../domain/usecases/settings/settings_usecases.dart';
import 'settings_state.dart';

/// **SettingsCubit** — Presentation ViewModel for app-wide UI settings.
///
/// Subscribes to [AppSessionRepository.settingsStream] so any change
/// (from THIS cubit or any other component) is instantly reflected.
/// Registered as LazySingleton in DI — one instance for the whole app.
class SettingsCubit extends Cubit<SettingsState> {
  final LoadSettingsUseCase loadSettingsUseCase;
  final SaveThemeUseCase saveThemeUseCase;
  final SaveLocaleUseCase saveLocaleUseCase;
  final AppSessionRepository repository;

  StreamSubscription<dynamic>? _subscription;

  SettingsCubit({
    required this.loadSettingsUseCase,
    required this.saveThemeUseCase,
    required this.saveLocaleUseCase,
    required this.repository,
  }) : super(const SettingsState.initial()) {
    _subscribeToStream();
  }

  void _subscribeToStream() {
    _subscription = repository.settingsStream.listen((settings) {
      emit(
        SettingsState(themeMode: settings.themeMode, locale: settings.locale),
      );
    });
  }

  // /// Load persisted settings from DB. Call once in main() or initState.
  Future<void> loadSettings() async {
    final result = await loadSettingsUseCase();
    result.fold(
      (_) {},
      (settings) => emit(
        SettingsState(themeMode: settings.themeMode, locale: settings.locale),
      ),
    );
  }

  // /// Persist and broadcast new theme mode.
  Future<void> changeTheme(ThemeMode themeMode) async {
    await saveThemeUseCase(themeMode);
  }

  // /// Persist and broadcast new locale.
  Future<void> changeLocale(Locale locale) async {
    await saveLocaleUseCase(locale);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
