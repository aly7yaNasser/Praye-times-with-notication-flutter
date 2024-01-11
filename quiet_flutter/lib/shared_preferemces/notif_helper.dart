import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs_and_cubits/notification/notify_cubit.dart';

class NotifHelper {
  static const String notifiyKey = "NOTIF";
  Future<void> cacheNotification(String notifiy) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(notifiyKey, notifiy);
  }

  Future<String> getCachedNotification() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final cachedNotifiy = sharedPreferences.getString(notifiyKey);

    if (cachedNotifiy != null) {
      return cachedNotifiy;
    } else {
      final isPerGranted = await Permission.notification.isGranted;
      if (isPerGranted) {
        return NotifyChangedState.NOTIFY_ENABLED;
      } else {
        return NotifyChangedState.NOTIFY_DISABLED;
      }
    }

  }
}