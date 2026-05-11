import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/l10n_extension.dart';
import '../blocs/settings/settings_cubit.dart';
import '../blocs/settings/settings_state.dart';

/// Available languages with display labels (shown in native script).
const _supportedLocales = [
  (code: 'en', label: 'English'),
  (code: 'hi', label: 'हिन्दी'),
  (code: 'ta', label: 'தமிழ்'),
  (code: 'ru', label: 'Русский'),
  (code: 'ja', label: '日本語'),
];

/// **SettingsPage**
/// Allows users to toggle theme (Light / Dark / System) and select
/// a supported language. Changes are applied immediately and persisted
/// to SQLite via [SettingsCubit] → [AppSessionRepository].
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings), centerTitle: true),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // ─── Theme Section ───────────────────────────────────────────
              _SectionHeader(title: l10n.theme),
              const SizedBox(height: 12),
              _ThemeSegmentedButton(currentMode: state.themeMode),

              const SizedBox(height: 32),

              // ─── Language Section ─────────────────────────────────────────
              _SectionHeader(title: l10n.language),
              const SizedBox(height: 12),
              _LanguageDropdown(currentLocale: state.locale),

              const SizedBox(height: 40),

              // ─── App Info ─────────────────────────────────────────────────
              Center(
                child: Text(
                  'SkyCast v1.0.0',
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.45),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Section header with styled label.
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

/// Segmented button for Light / Dark / System theme selection.
class _ThemeSegmentedButton extends StatelessWidget {
  final ThemeMode currentMode;
  const _ThemeSegmentedButton({required this.currentMode});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SegmentedButton<ThemeMode>(
          selected: {currentMode},
          onSelectionChanged: (selected) =>
              context.read<SettingsCubit>().changeTheme(selected.first),
          segments: [
            ButtonSegment(
              value: ThemeMode.light,
              icon: const Icon(Icons.light_mode_rounded),
              label: Text(l10n.themeLight),
            ),
            ButtonSegment(
              value: ThemeMode.system,
              icon: const Icon(Icons.brightness_auto_rounded),
              label: Text(l10n.themeSystem),
            ),
            ButtonSegment(
              value: ThemeMode.dark,
              icon: const Icon(Icons.dark_mode_rounded),
              label: Text(l10n.themeDark),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dropdown for language selection.
class _LanguageDropdown extends StatelessWidget {
  final Locale currentLocale;
  const _LanguageDropdown({required this.currentLocale});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentEntry = _supportedLocales.firstWhere(
      (l) => l.code == currentLocale.languageCode,
      orElse: () => _supportedLocales.first,
    );

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: currentEntry.code,
            isExpanded: true,
            icon: Icon(Icons.language_rounded, color: colorScheme.primary),
            items: _supportedLocales
                .map(
                  (l) => DropdownMenuItem(
                    value: l.code,
                    child: Text(l.label, style: const TextStyle(fontSize: 16)),
                  ),
                )
                .toList(),
            onChanged: (code) {
              if (code != null) {
                context.read<SettingsCubit>().changeLocale(Locale(code));
              }
            },
          ),
        ),
      ),
    );
  }
}
