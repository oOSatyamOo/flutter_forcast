// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'SkyCast';

  @override
  String get searchHint => '都市を検索...';

  @override
  String get threeDayForecast => '3日間の予報';

  @override
  String get hourlyForecast => '時間別予報';

  @override
  String get dailyOverview => '日次概要';

  @override
  String get searchForCity => '都市を検索してください';

  @override
  String get offlineMessage => 'オフラインです。キャッシュデータを表示しています。';

  @override
  String apiErrorMessage(String message) {
    return 'APIエラー: $message。キャッシュデータを表示しています。';
  }

  @override
  String get tryAgain => 'もう一度試す';

  @override
  String get settings => '設定';

  @override
  String get theme => 'テーマ';

  @override
  String get language => '言語';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get themeSystem => 'システム';

  @override
  String get maxTemp => '最高気温';

  @override
  String get minTemp => '最低気温';

  @override
  String get condition => '天気';

  @override
  String get goHome => 'ホームへ';

  @override
  String pageNotFound(String path) {
    return 'ページが見つかりません: $path';
  }

  @override
  String deepLinkMessage(String city) {
    return '\"$city\" にリンクされました。\nホーム画面で検索して完全な予報をご確認ください。';
  }

  @override
  String get deepLinkMessageEmpty => 'ホーム画面で都市を検索して完全な予報をご確認ください。';
}
