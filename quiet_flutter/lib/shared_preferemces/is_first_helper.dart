import 'dart:developer';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class IsFirstHelper {
  static const String IsFirstKey = "IsFirst";

  Future<void> cacheIsFirst(bool IsFirst) async {
    // print('LangCode: ${IsFirst}');
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(IsFirstKey, IsFirst);
  }

  Future<bool> getCachedIsFirst() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final cachedIsFirst = sharedPreferences.getBool(IsFirstKey);
    if (cachedIsFirst != null) {
      return cachedIsFirst;
    } else {

        return true;
    }
  }
}