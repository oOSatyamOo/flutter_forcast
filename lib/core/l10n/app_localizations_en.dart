// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SkyCast';

  @override
  String get searchHint => 'Search city...';

  @override
  String get threeDayForecast => '3-Day Forecast';

  @override
  String get hourlyForecast => 'Hourly Forecast';

  @override
  String get dailyOverview => 'Daily Overview';

  @override
  String get searchForCity => 'Search for a city';

  @override
  String get offlineMessage => 'You are offline. Showing cached data.';

  @override
  String apiErrorMessage(String message) {
    return 'API Error: $message. Showing cached data.';
  }

  @override
  String get tryAgain => 'Try Again';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get maxTemp => 'Max Temp';

  @override
  String get minTemp => 'Min Temp';

  @override
  String get condition => 'Condition';

  @override
  String get goHome => 'Go to Home';

  @override
  String pageNotFound(String path) {
    return 'Page not found: $path';
  }

  @override
  String deepLinkMessage(String city) {
    return 'You were linked to \"$city\".\nSearch for it on the home screen to view the full forecast.';
  }

  @override
  String get deepLinkMessageEmpty =>
      'Search for a city on the home screen to view the full forecast.';
}
