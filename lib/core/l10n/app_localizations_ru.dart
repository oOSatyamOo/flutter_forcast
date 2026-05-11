// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'SkyCast';

  @override
  String get searchHint => 'Поиск города...';

  @override
  String get threeDayForecast => 'Прогноз на 3 дня';

  @override
  String get hourlyForecast => 'Почасовой прогноз';

  @override
  String get dailyOverview => 'Дневной обзор';

  @override
  String get searchForCity => 'Найдите город';

  @override
  String get offlineMessage => 'Вы офлайн. Показаны кэшированные данные.';

  @override
  String apiErrorMessage(String message) {
    return 'Ошибка API: $message. Показаны кэшированные данные.';
  }

  @override
  String get tryAgain => 'Повторить';

  @override
  String get settings => 'Настройки';

  @override
  String get theme => 'Тема';

  @override
  String get language => 'Язык';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get themeSystem => 'Системная';

  @override
  String get maxTemp => 'Макс. темп.';

  @override
  String get minTemp => 'Мин. темп.';

  @override
  String get condition => 'Погода';

  @override
  String get goHome => 'На главную';

  @override
  String pageNotFound(String path) {
    return 'Страница не найдена: $path';
  }

  @override
  String deepLinkMessage(String city) {
    return 'Вы перешли по ссылке на \"$city\".\nИщите на главном экране для просмотра прогноза.';
  }

  @override
  String get deepLinkMessageEmpty =>
      'Найдите город на главном экране для просмотра прогноза.';
}
