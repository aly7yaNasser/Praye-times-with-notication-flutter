import 'dart:developer';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class AutoStartHelper {
  static const String autoStartKey = "AUTOSTART";
  static const String AUTOSTARTENABLED = "ENABLED";
  static const String AUTOSTARTDISABLED = "DISABLED";
  Future<void> cacheAutoStart(String AutoStart) async {
    // print('LangCode: ${AutoStart}');
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(autoStartKey, AutoStart);
  }

  Future<String> getCachedAutoStart() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final cachedAutoStart = sharedPreferences.getString(autoStartKey);
    if (cachedAutoStart != null) {
      return cachedAutoStart;
    } else {

        return AUTOSTARTDISABLED;
    }
  }
}