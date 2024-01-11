 import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';

import '../blocs_and_cubits/prayer_times_api/prayer_time_api_bloc.dart';
import '../main.dart';
import '../models/prayer_time.dart';
import '../services/notification_service.dart';
 import 'package:intl/intl.dart';

class GeneralStatic {
   static bool isPrayertimeShown = false;

   @pragma('vm:entry-point')
   static FutureOr<dynamic> someFunction(String arg) {
      print("Running in an isolate with argument : $arg");
      return 1;
   }


   static initHive() async {
      await Hive.initFlutter();
      if (!Hive.isAdapterRegistered(1)) {
         Hive.registerAdapter(PrayerTimeAdapter());
      }
      if (!Hive.isAdapterRegistered(2)) {
         Hive.registerAdapter(DateAdapter());
      }
      if (!Hive.isAdapterRegistered(3)) {
         Hive.registerAdapter(GregorianAdapter());
      }
      if (!Hive.isAdapterRegistered(5)) {
         Hive.registerAdapter(HijriAdapter());
      }
      if (!Hive.isAdapterRegistered(6)) {
         Hive.registerAdapter(WeekdayAdapter());
      }
      if (!Hive.isAdapterRegistered(7)) {
         Hive.registerAdapter(MonthAdapter());
      }
      if (!Hive.isAdapterRegistered(4)) {
         Hive.registerAdapter(DesignationAdapter());
      }
   }



   static void callbackDispatcher() {
      Workmanager().executeTask((task, inputdata) async {
         try {
            String lunchTime = DateFormat('hh:mm:ss').format(DateTime.now());

            final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();

            /// Streams are created so that app can respond to notification-related events
            /// since the plugin is initialised in the `main` function
            final StreamController<ReceivedNotification>
            didReceiveLocalNotificationStream =
            StreamController<ReceivedNotification>.broadcast();

            final StreamController<String?> selectNotificationStream =
            StreamController<String?>.broadcast();

            const MethodChannel platform =
            MethodChannel('dexterx.dev/flutter_local_notifications_example');

            const String portName = 'notification_send_port';

            String? selectedNotificationPayload;

            /// A notification action which triggers a url launch event
            const String urlLaunchActionId = 'id_1';

            /// A notification action which triggers a App navigation event
            const String navigationActionId = 'id_3';

            /// Defines a iOS/MacOS notification category for text input actions.
            const String darwinNotificationCategoryText = 'textCategory';

            /// Defines a iOS/MacOS notification category for plain actions.
            const String darwinNotificationCategoryPlain = 'plainCategory';

            await WidgetsFlutterBinding.ensureInitialized();

            const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('ic_launcher');

            final List<DarwinNotificationCategory> darwinNotificationCategories =
            <DarwinNotificationCategory>[
               DarwinNotificationCategory(
                  darwinNotificationCategoryText,
                  actions: <DarwinNotificationAction>[
                     DarwinNotificationAction.text(
                        'text_1',
                        'Action 1',
                        buttonTitle: 'Send',
                        placeholder: 'Placeholder',
                     ),
                  ],
               ),
               DarwinNotificationCategory(
                  darwinNotificationCategoryPlain,
                  actions: <DarwinNotificationAction>[
                     DarwinNotificationAction.plain('id_1', 'Action 1'),
                     DarwinNotificationAction.plain(
                        'id_2',
                        'Action 2 (destructive)',
                        options: <DarwinNotificationActionOption>{
                           DarwinNotificationActionOption.destructive,
                        },
                     ),
                     DarwinNotificationAction.plain(
                        navigationActionId,
                        'Action 3 (foreground)',
                        options: <DarwinNotificationActionOption>{
                           DarwinNotificationActionOption.foreground,
                        },
                     ),
                     DarwinNotificationAction.plain(
                        'id_4',
                        'Action 4 (auth required)',
                        options: <DarwinNotificationActionOption>{
                           DarwinNotificationActionOption.authenticationRequired,
                        },
                     ),
                  ],
                  options: <DarwinNotificationCategoryOption>{
                     DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
                  },
               )
            ];

            /// Note: permissions aren't requested here just to demonstrate that can be
            /// done later
            final DarwinInitializationSettings initializationSettingsDarwin =
            DarwinInitializationSettings(
               requestAlertPermission: false,
               requestBadgePermission: false,
               requestSoundPermission: false,
               onDidReceiveLocalNotification:
                   (int id, String? title, String? body, String? payload) async {
                  didReceiveLocalNotificationStream.add(
                     ReceivedNotification(
                        id: id,
                        title: title,
                        body: body,
                        payload: payload,
                     ),
                  );
               },
               notificationCategories: darwinNotificationCategories,
            );
            final LinuxInitializationSettings initializationSettingsLinux =
            LinuxInitializationSettings(
               defaultActionName: 'Open notification',
               defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
            );
            final InitializationSettings initializationSettings =
            InitializationSettings(
               android: initializationSettingsAndroid,
               iOS: initializationSettingsDarwin,
               macOS: initializationSettingsDarwin,
               linux: initializationSettingsLinux,
            );

            await flutterLocalNotificationsPlugin.initialize(
               initializationSettings,
               onDidReceiveNotificationResponse:
                   (NotificationResponse notificationResponse) {
                  switch (notificationResponse.notificationResponseType) {
                     case NotificationResponseType.selectedNotification:
                        selectNotificationStream.add(notificationResponse.payload);
                        break;
                     case NotificationResponseType.selectedNotificationAction:
                        if (notificationResponse.actionId == navigationActionId) {
                           selectNotificationStream.add(notificationResponse.payload);
                        }
                        break;
                  }
               },
               onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
            );



            // await _configureLocalTimeZone();
            // log('waiting 5s');
            // await Future.delayed(Duration(seconds: 5));
            // await _zonedScheduleAlarmClockNotification(
            //     flutterLocalNotificationsPlugin, 5000);
            // log('finsh 5s');
            // if (task != 'init') {
            //   // await NotificationService()
            //   //     .showNotification(title: 'Prayer Time', body: '2.5', id: 12);
            //   String lang = await LocaleHelper().getCachedLanguageCode();
            //   String body = lang == 'en' ? 'Allah akbar' : 'ألله أكبر';
            //   String title = lang == 'en' ? 'Prayer Times' : 'أوقات الصلاة';
            //   await NotificationService()
            //       .showNotification(title: title,
            //     body: body, id: 0,
            //   );
            // }
            // log('waiting 15 seconds');
            // await Future.delayed(Duration(seconds: 15));
            // await NotificationService()
            //     .showNotification(title: 'Prayer Time', body: task, id: 200);

            // await NotificationService()
            //     .showNotification(title: 'Prayer Time', body: '1', id: 11);

            await initHive();
            // await NotificationService().initNotification();
            // await NotificationService()
            //     .showNotification(title: 'Prayer Time', body: '2', id: 12);

            log('task');

            // await NotificationService()
            //     .showNotification(title: 'Prayer Time', body: 'init', id: -1);

            // await NotificationService()
            //     .showNotification(title: 'Prayer Time', body: '3', id: 13);

            var prayerTimeBox = await Hive.openBox(PrayerTimeApiBloc.prayerTimeKey);
            List boxList = [];
            List<PrayerTime> prayerTimes = [];
            // await NotificationService()
            //     .showNotification(title: 'Prayer Time', body: '4', id: 14);

            boxList = await (prayerTimeBox
                .get(PrayerTimeApiBloc.prayerTimeKey, defaultValue: []));

            // await NotificationService()
            //     .showNotification(title: 'Prayer Time', body: '5', id: 15);
            prayerTimes = List<PrayerTime>.from(boxList);
            DateTime now = DateTime.now();
            var launchDate = DateFormat('dd MMM yyyy').format(now);
            log('lunchDate: $launchDate');

            var nextDayDateForPT = DateFormat('dd MMM yyyy').format(
                DateTime(now.year, now.month, now.day + 1));
            var nextDayDateForDaily = DateFormat('yyyy-MM-dd')
                .format(DateTime(now.year, now.month, now.day + 1));
            String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
            log('nextDayDate: $nextDayDateForPT');

            DateTime nextScheduleDateTime =
            DateTime.parse(nextDayDateForDaily + ' ' + '02:00:00.000');
            log('nextSchedule:  ${nextScheduleDateTime.year}/${nextScheduleDateTime.month}/${nextScheduleDateTime.day} ${nextScheduleDateTime.hour}:${nextScheduleDateTime.minute}');

            if (prayerTimes.isNotEmpty) {
               // await NotificationService()
               //   .showNotification(title: 'Prayer Time', body: '6', id: 16);
               log('lunchDate: $launchDate');
               PrayerTime currentPrayerTime = prayerTimes.firstWhere(
                       (PrayerTime prayerTime) =>
                   prayerTime.date!.readable == launchDate);

               // await NotificationService()
               //     .showNotification(title: 'Prayer Time', body: '7', id: 17);
               //
               if (currentPrayerTime != null) {
                  bool isScheduled = await currentPrayerTime.scheduleNotifications();
                  log('isScheduled 1: $isScheduled');
                  if (!isScheduled) {
                     //   int? nextPrayerTime = await currentPrayerTime.getNextPrayerTime();
                     //
                     //   // await NotificationService()
                     //   //     .showNotification(title: 'Prayer Time', body: '8', id: 18);
                     //   //
                     //   if (nextPrayerTime == null) {
                     log('before getting Next Day');
                     PrayerTime currentPrayerTime = prayerTimes.firstWhere((
                         PrayerTime prayerTime) =>
                     prayerTime.date!.readable == nextDayDateForPT);
                     log('after getting Next Day');

                     isScheduled = await currentPrayerTime.scheduleNotifications();
                     log('isScheduled 2: $isScheduled');

                     //     // await NotificationService()
                     //     //     .showNotification(title: 'Prayer Time', body: '9', id: 19);
                     //   }
                     //   if (nextPrayerTime != null) {
                     //     // await NotificationService()
                     //       // .showNotification(title: 'Prayer Time', body: '10', id: 110);
                     //
                     //     log('nextPTMilli: $nextPrayerTime');
                     //     Duration remaningTimeFoePrayerTime = Duration(
                     //         milliseconds: nextPrayerTime - now.millisecondsSinceEpoch);
                     //
                     //     // await NotificationService()
                     //     //     .showNotification(title: "Prayer Time", body: 'Next: ${remaningTimeFoePrayerTime.inHours}:${remaningTimeFoePrayerTime.inMinutes % 60}:${remaningTimeFoePrayerTime.inSeconds % 60} ',
                     //     // id:-10);
                     //
                     //
                     //     await NotificationService()
                     //         .showNotification(title: "Prayer Time", body: 'Triggered : $lunchTime ',
                     //         id:-11);
                     //
                     //     log('remaining: $remaningTimeFoePrayerTime');
                     //
                     //     log('task: $task');
                     //
                     //     //   await NotificationService()
                     //     //       .showNotification(title: 'Prayer Time', body: '11', id: 111);
                     //       Workmanager().registerOneOffTask(
                     //         "init",
                     //         "init",
                     //         initialDelay: remaningTimeFoePrayerTime,
                     //         constraints: Constraints(
                     //             networkType: NetworkType.not_required,
                     //             requiresDeviceIdle: false,
                     //             requiresBatteryNotLow: false,
                     //             requiresStorageNotLow: false),
                     //         existingWorkPolicy: ExistingWorkPolicy.replace,
                     //       );
                     //
                     //   }
                     // } else {
                  }
               }
               await NotificationService()
                   .showNotification(title: 'Prayer Time', body: task, id: 200);

               await         WidgetsFlutterBinding.ensureInitialized();

               await Workmanager()
                   .initialize(callbackDispatcher, isInDebugMode: true);

               if (task == "4") {
                  Workmanager().registerOneOffTask(
                     "3",
                     "3",
                     initialDelay: Duration(
                         milliseconds: //nextScheduleDateTime.millisecondsSinceEpoch -
                         now.millisecondsSinceEpoch + (1000 * 60 * 1)),
                     constraints: Constraints(
                         networkType: NetworkType.not_required,
                         requiresDeviceIdle: false,
                         requiresBatteryNotLow: false,
                         requiresStorageNotLow: false),
                     existingWorkPolicy: ExistingWorkPolicy.replace,
                  );

                  await Workmanager().cancelByUniqueName("4");

               }else{

                  Workmanager().registerOneOffTask(
                     "4",
                     "4",
                     initialDelay: Duration(
                         milliseconds: //nextScheduleDateTime.millisecondsSinceEpoch -
                         now.millisecondsSinceEpoch + (1000 * 60 * 1)),
                     constraints: Constraints(
                         networkType: NetworkType.not_required,
                         requiresDeviceIdle: false,
                         requiresBatteryNotLow: false,
                         requiresStorageNotLow: false),
                     existingWorkPolicy: ExistingWorkPolicy.replace,
                  );

                  await Workmanager().cancelByUniqueName("3");

               }
            }
            // else
            // }
            log('workMan taskName: $task');

            return Future.value(true);
            // }
            return Future(() => false);
         } catch (err) {
            log('quietError :${err.toString()}'); // Logger flutter package, prints error on the debug console
            throw Exception(err);
         }
      });
   }
}