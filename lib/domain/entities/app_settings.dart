import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// **AppSettings** — Pure domain entity.
/// Represents the user's persisted UI preferences.
/// Has zero dependency on Flutter widgets beyond [ThemeMode] and [Locale],
/// which are stable Flutter framework types safe to use in the domain layer.
class AppSettings extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;

  const AppSettings({
    required this.themeMode,
    required this.locale,
  });

  static const defaultSettings = AppSettings(
    themeMode: ThemeMode.system,
    locale: Locale('en'),
  );

  AppSettings copyWith({ThemeMode? themeMode, Locale? locale}) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [themeMode, locale];
}
