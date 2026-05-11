// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'आसमान';

  @override
  String get searchHint => 'शहर खोजें...';

  @override
  String get threeDayForecast => '3 दिन का पूर्वानुमान';

  @override
  String get hourlyForecast => 'प्रति घंटा पूर्वानुमान';

  @override
  String get dailyOverview => 'दैनिक अवलोकन';

  @override
  String get searchForCity => 'एक शहर खोजें';

  @override
  String get offlineMessage => 'आप ऑफलाइन हैं। कैश्ड डेटा दिखा रहे हैं।';

  @override
  String apiErrorMessage(String message) {
    return 'API त्रुटि: $message। कैश्ड डेटा दिखा रहे हैं।';
  }

  @override
  String get tryAgain => 'पुनः प्रयास करें';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get theme => 'थीम';

  @override
  String get language => 'भाषा';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeDark => 'डार्क';

  @override
  String get themeSystem => 'सिस्टम';

  @override
  String get maxTemp => 'अधिकतम तापमान';

  @override
  String get minTemp => 'न्यूनतम तापमान';

  @override
  String get condition => 'स्थिति';

  @override
  String get goHome => 'होम पर जाएं';

  @override
  String pageNotFound(String path) {
    return 'पृष्ठ नहीं मिला: $path';
  }

  @override
  String deepLinkMessage(String city) {
    return 'आपको \"$city\" से लिंक किया गया था।\nपूरा पूर्वानुमान देखने के लिए होम स्क्रीन पर खोजें।';
  }

  @override
  String get deepLinkMessageEmpty =>
      'पूरा पूर्वानुमान देखने के लिए होम स्क्रीन पर एक शहर खोजें।';
}
