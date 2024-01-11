import 'dart:developer';
import 'dart:ui';

import 'package:devicelocale/devicelocale.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleHelper {
  static const String localKey = "LOCALE";
  Future<void> cacheLanguageCode(String languageCode) async {
    // print('LangCode: ${languageCode}');
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(localKey, languageCode);
  }

  Future<String> getCachedLanguageCode() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final cachedLanguageCode = sharedPreferences.getString(localKey);
    if (cachedLanguageCode != null) {
      return cachedLanguageCode;
    } else {
      List<String> supportedLocales = ['ar', 'en'];
      String? deviceLocale = await Devicelocale.currentLocale;
        String? deviceLang = deviceLocale!.split('-')[0];
        log('deviceLang: ${deviceLang!}');
        return deviceLang;
    }
  }
}