import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quiet_flutter/delegates/app_localization.dart';

import 'package:workmanager/workmanager.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../models/prayer_time.dart';
import '../../services/notification_service.dart';
import '../../shared_preferemces/location_helper.dart';
import '../../shared_preferemces/notif_helper.dart';
import '../prayer_times_api/prayer_time_api_bloc.dart';

part 'notify_state.dart';

class NotifyCubit extends Cubit<NotifyChangedState> {
  NotifyCubit()
      : super(NotifyChangedState(
            notifyOption: NotifyChangedState.NOTIFY_DISABLED, init: true)) {}

  getSavedNotifyValue() async {
    log('NotifSaved');

    String notifyOption = await NotifHelper().getCachedNotification();

    emit(NotifyChangedState(notifyOption: notifyOption));
  }

  NotifyValueChanged(String notifyOption, BuildContext? context) async {
    log('notif changed');
    try{
    await Workmanager().cancelAll();
    // .then((value) async {
      log('notifStart cancelled');
      log('notifStart notifyOption: ${notifyOption}');

    await flutterLocalNotificationsPlugin.cancelAll();


    if (notifyOption == NotifyChangedState.NOTIFY_ENABLED) {
        bool isGranted = await Permission.notification.isGranted;
        log('notifStart isGranted1: ${isGranted}');

        if (!isGranted) {
          // await PermissionService().requestPermission(Permission.notification);
          await       _requestPermissions();

          isGranted = await Permission.notification.isGranted;
          log('notifStart isGranted2: ${isGranted}');
        }
        if (!isGranted) {
          if (context != null) {
            Fluttertoast.showToast(
                msg: "enable notification".tr(context),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }

          notifyOption = NotifyChangedState.NOTIFY_DISABLED;
        }

        if (isGranted) {
          log('notifStart isGranted3: ${isGranted}');
          await runNotifications();

        }
      }

      log('notifStart notifOption: ${notifyOption}');

      await NotifHelper().cacheNotification(notifyOption);

      emit(NotifyChangedState(notifyOption: notifyOption));
    // });
    return Future.value(true);
    // }
    return Future(() => false);
  } catch(err) {
  log('quietError :${err.toString()}'); // Logger flutter package, prints error on the debug console
  throw Exception(err);
  }
  }

  Future runNotifications() async {
    log('notif: enabled');
    // Workmanager().registerOneOffTask(
    //   "init",
    //   'init',
    //   initialDelay: Duration(seconds: 60),
    //   // frequency: Duration(minutes: 16),
    //   constraints: Constraints(
    //       networkType: NetworkType.not_required,
    //       requiresDeviceIdle: false,
    //       requiresBatteryNotLow: false,
    //       requiresStorageNotLow: false,
    //       requiresCharging: false),
    //   existingWorkPolicy: ExistingWorkPolicy.replace,
    // );
    Workmanager().registerOneOffTask(
      "init",
      'init',
      initialDelay: Duration(seconds: 1),
      // frequency: Duration(minutes: 16),
      constraints: Constraints(
          networkType: NetworkType.not_required,
          requiresDeviceIdle: false,
          requiresBatteryNotLow: false,
          requiresStorageNotLow: false,
          requiresCharging: false),
      existingWorkPolicy: ExistingWorkPolicy.keep,
    );

    log('notif: enabled FTER');
    // NotificationService().showNotification(
    //     title: 'Prayer Time', body: 'notifStat starts', id: 6);
    log('notif:  FTER');
  }


  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
      await androidImplementation?.requestNotificationsPermission();

    }
  }
}

