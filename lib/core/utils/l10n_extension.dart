import 'package:flutter/widgets.dart';
import 'package:skycast/core/l10n/app_localizations.dart';

extension L10nContextExtension on BuildContext {
  /// Provides a non-nullable [AppLocalizations] instance.
  /// If the context does not contain localizations (e.g., during initialization
  /// or testing without a wrapper), it falls back to the default English localization
  /// to ensure zero hardcoded strings are needed in the UI.
  AppLocalizations get l10n =>
      AppLocalizations.of(this) ?? lookupAppLocalizations(const Locale('en'));
}
