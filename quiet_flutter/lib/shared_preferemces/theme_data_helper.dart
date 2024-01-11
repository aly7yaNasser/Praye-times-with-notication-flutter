import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class themeHelper {
  static const String themeDataKey = "THEMEDATA";
  Future<void> cacheTheme(String ThemeData) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(themeDataKey, ThemeData);
  }

  Future<String > getCachedTheme() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final cachedThemeData = sharedPreferences.getString(themeDataKey);

    if (cachedThemeData != null) {
      return cachedThemeData;
    } else {
      return "light";
    }

  }
}