// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appName => 'SkyCast';

  @override
  String get searchHint => 'நகரத்தை தேடுங்கள்...';

  @override
  String get threeDayForecast => '3-நாள் முன்னறிவிப்பு';

  @override
  String get hourlyForecast => 'மணிநேர முன்னறிவிப்பு';

  @override
  String get dailyOverview => 'தினசரி கண்ணோட்டம்';

  @override
  String get searchForCity => 'ஒரு நகரத்தை தேடுங்கள்';

  @override
  String get offlineMessage =>
      'நீங்கள் ஆஃப்லைனில் இருக்கிறீர்கள். தற்காலிக தரவை காட்டுகிறோம்.';

  @override
  String apiErrorMessage(String message) {
    return 'API பிழை: $message. தற்காலிக தரவை காட்டுகிறோம்.';
  }

  @override
  String get tryAgain => 'மீண்டும் முயற்சிக்கவும்';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get theme => 'தீம்';

  @override
  String get language => 'மொழி';

  @override
  String get themeLight => 'வெளிச்சம்';

  @override
  String get themeDark => 'இருள்';

  @override
  String get themeSystem => 'கணினி';

  @override
  String get maxTemp => 'அதிகபட்ச வெப்பம்';

  @override
  String get minTemp => 'குறைந்தபட்ச வெப்பம்';

  @override
  String get condition => 'நிலை';

  @override
  String get goHome => 'முகப்பிற்கு செல்லவும்';

  @override
  String pageNotFound(String path) {
    return 'பக்கம் கிடைக்கவில்லை: $path';
  }

  @override
  String deepLinkMessage(String city) {
    return '\"$city\" என்பதற்கு இணைக்கப்பட்டீர்கள்.\nமுழு முன்னறிவிப்பை பார்க்க முகப்பு திரையில் தேடுங்கள்.';
  }

  @override
  String get deepLinkMessageEmpty =>
      'முழு முன்னறிவிப்பை பார்க்க முகப்பு திரையில் ஒரு நகரத்தை தேடுங்கள்.';
}
