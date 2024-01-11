import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../shared_preferemces/locale_helper.dart';
class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {

    AndroidInitializationSettings initializationSettingsAndroid =
    const AndroidInitializationSettings('ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
      channelDescription: 'your other channel description',
      // sound: RawResourceAndroidNotificationSound('prayer_time_norify_sound'),
        importance: Importance.max
    );
    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      // sound: 'prayerTimeNorifySound.aiff'
    );
    // final NotificationDetails notificationDetails = NotificationDetails(
    //   android: androidNotificationDetails,
    //   iOS: darwinNotificationDetails,
    // );
    return const NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails);
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  NotificationDetails notificationDetailsWithAdhan() {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
      channelDescription: 'your other channel description',
      sound: RawResourceAndroidNotificationSound('prayer_time_norify_sound'),
        importance: Importance.max,
      priority: Priority.max
    );
    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      sound: 'prayerTimeNorifySound.aiff'
    );
    // final NotificationDetails notificationDetails = NotificationDetails(
    //   android: androidNotificationDetails,
    //   iOS: darwinNotificationDetails,
    // );
    return const NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails);
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {required int id, required String title, required String body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, id == 0 ? await notificationDetailsWithAdhan() : await notificationDetails());
  }

  Future<void> zonedScheduleAlarmClockNotification(int duration) async {

      String lang = await LocaleHelper().getCachedLanguageCode();
      String body = lang == 'en' ? 'Allah akbar' : 'ألله أكبر';
      String title = lang == 'en' ? 'Prayer Times' : 'أوقات الصلاة';
    await notificationsPlugin.zonedSchedule(
        123,
        title,
        body,
        tz.TZDateTime.now(tz.local).add( Duration(milliseconds: duration)),
        await notificationDetailsWithAdhan(),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }
}

//
// import 'dart:async';
// import 'dart:io';
//
//
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_timezone/flutter_timezone.dart';
//
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
//
// import '../main.dart';
//
// int id = 0;
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
//
// /// Streams are created so that app can respond to notification-related events
// /// since the plugin is initialised in the `main` function
// final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
// StreamController<ReceivedNotification>.broadcast();
//
// final StreamController<String?> selectNotificationStream = StreamController<String?>.broadcast();
//
// const MethodChannel platform = MethodChannel('dexterx.dev/flutter_local_notifications_example');
//
// const String portName = 'notification_send_port';
//
// class ReceivedNotification {
//   ReceivedNotification({
//     required this.id,
//     required this.title,
//     required this.body,
//     required this.payload,
//   });
//
//   final int id;
//   final String? title;
//   final String? body;
//   final String? payload;
// }
//
// String? selectedNotificationPayload;
//
// /// A notification action which triggers a url launch event
// const String urlLaunchActionId = 'id_1';
//
// /// A notification action which triggers a App navigation event
// const String navigationActionId = 'id_3';
//
// /// Defines a iOS/MacOS notification category for text input actions.
// const String darwinNotificationCategoryText = 'textCategory';
//
// /// Defines a iOS/MacOS notification category for plain actions.
// const String darwinNotificationCategoryPlain = 'plainCategory';
// class NotificationService {
//
//   @pragma('vm:entry-point')
//   void notificationTapBackground(NotificationResponse notificationResponse) {
//     // ignore: avoid_print
//     print('notification(${notificationResponse.id}) action tapped: '
//         '${notificationResponse.actionId} with'
//         ' payload: ${notificationResponse.payload}');
//     if (notificationResponse.input?.isNotEmpty ?? false) {
//       // ignore: avoid_print
//       print('notification action tapped with input: ${notificationResponse
//           .input}');
//     }
//   }
//
//   /// IMPORTANT: running the following code on its own won't work as there is
//   /// setup required for each platform head project.
//   ///
//   /// Please download the complete example app from the GitHub repository where
//   /// all the setup has been done
//   Future<void> ScheduleNotif() async {
//     // needed if you intend to initialize in the `main` function
//     //
//     // await _configureLocalTimeZone();
//     //
//     //
//     // await _zonedScheduleAlarmClockNotification(5000);
//
//
//     // runApp(
//     //   MaterialApp(
//     //     initialRoute: initialRoute,
//     //     routes: <String, WidgetBuilder>{
//     //       HomePage.routeName: (_) => HomePage(notificationAppLaunchDetails),
//     //       SecondPage.routeName: (_) => SecondPage(selectedNotificationPayload)
//     //     },
//     //   ),
//     // );
//   }
//
//  //
//  // static Future<void> _zonedScheduleAlarmClockNotification(int milliSeconds) async {
//  //    await flutterLocalNotificationsPlugin.zonedSchedule(
//  //        123,
//  //        'scheduled alarm clock title',
//  //        'scheduled alarm clock body',
//  //        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
//  //        const NotificationDetails(
//  //            android: AndroidNotificationDetails(
//  //                'alarm_clock_channel', 'Alarm Clock Channel',
//  //                channelDescription: 'Alarm Clock Notification')),
//  //        androidScheduleMode: AndroidScheduleMode.alarmClock,
//  //        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation
//  //            .absoluteTime);
//  //  }
//  //
//  //  Future<void> _configureLocalTimeZone() async {
//  //    if (kIsWeb || Platform.isLinux) {
//  //      return;
//  //    }
//  //    tz.initializeTimeZones();
//  //    final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
//  //    tz.setLocalLocation(tz.getLocation(timeZoneName!));
//  //  }
// }