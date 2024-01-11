import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quiet_flutter/services/notification_service.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:quiet_flutter/pages/main.dart';
import 'package:quiet_flutter/themes_and_styles/themes_constants.dart';
import 'package:workmanager/workmanager.dart';
import 'package:intl/intl.dart';

import 'blocs_and_cubits/Internet/internet_bloc.dart';
import 'blocs_and_cubits/locale_cubit/locale_cubit.dart';
import 'blocs_and_cubits/prayer_times_api/prayer_time_api_bloc.dart';
import 'blocs_and_cubits/theme_mode/theme_mode_cubit.dart';
import 'blocs_and_cubits/theme_mode/theme_mode_state.dart';
import 'blocs_and_cubits/time_format/time_format_cubit.dart';
import 'delegates/app_localization.dart';
import 'general/general_static.dart';
import 'models/prayer_time.dart';

int id = 0;

late Box box;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

const String portName = 'notification_send_port';

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

String? selectedNotificationPayload;

/// A notification action which triggers a url launch event
const String urlLaunchActionId = 'id_1';

/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';

/// Defines a iOS/MacOS notification category for text input actions.
const String darwinNotificationCategoryText = 'textCategory';

/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

/// IMPORTANT: running the following code on its own won't work as there is
/// setup required for each platform head project.
///
/// Please download the complete example app from the GitHub repository where
/// all the setup has been done

void _configureDidReceiveLocalNotificationSubject() {
  BuildContext? contetx;
  didReceiveLocalNotificationStream.stream
      .listen((ReceivedNotification receivedNotification) async {
    await showDialog(
      context: contetx!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: receivedNotification.title != null
            ? Text(receivedNotification.title!)
            : null,
        content: receivedNotification.body != null
            ? Text(receivedNotification.body!)
            : null,
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      SecondPage(receivedNotification.payload),
                ),
              );
            },
            child: const Text('Ok'),
          )
        ],
      ),
    );
  });
}

void _configureSelectNotificationSubject() {
  BuildContext? context;

  selectNotificationStream.stream.listen((String? payload) async {
    await Navigator.of(context!).push(MaterialPageRoute<void>(
      builder: (BuildContext context) => SecondPage(payload),
    ));
  });
}

Future<void> _configureLocalTimeZone() async {
  log('tz init1');

  if (kIsWeb || Platform.isLinux) {
    return;
  }
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
  log('tz init2');
}

void callbackDispatcher() {
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


      // await NotificationService()
      //     .showNotification(title: 'Prayer Time', body: '1', id: 11);

      await initHive();
      // await NotificationService()
      //     .showNotification(title: 'Prayer Time', body: '2', id: 12);

      log('task');

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

      var nextDayDateForPT = DateFormat('dd MMM yyyy')
          .format(DateTime(now.year, now.month, now.day + 1));
      var nextDayDateForDaily = DateFormat('yyyy-MM-dd')
          .format(DateTime(now.year, now.month, now.day + 1));
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      log('nextDayDate: $nextDayDateForPT');

      DateTime firstDailySchedule =
          DateTime.parse(nextDayDateForDaily + ' ' + '02:00:00.000');
      log('firstDailySchedule:  ${firstDailySchedule.year}/${firstDailySchedule.month}/${firstDailySchedule.day} ${firstDailySchedule.hour}:${firstDailySchedule.minute}');
      log('firstDailySchedule ${firstDailySchedule.millisecondsSinceEpoch}');

      DateTime secondDailySchedule =
          DateTime.parse(nextDayDateForDaily + ' ' + '14:00:00.000');
      log('secondDailySchedule:  ${secondDailySchedule.year}/${secondDailySchedule.month}/${secondDailySchedule.day} ${secondDailySchedule.hour}:${secondDailySchedule.minute}');
      log('secondDailySchedule ${secondDailySchedule.millisecondsSinceEpoch}');

      if (prayerTimes.isNotEmpty) {

        // await NotificationService()
        //     .showNotification(title: 'Prayer Time', body: '6', id: 16);

        log('lunchDate: $launchDate');
        PrayerTime currentPrayerTime = prayerTimes.firstWhere(
            (PrayerTime prayerTime) => prayerTime.date!.readable == launchDate);

        // await NotificationService()
        //     .showNotification(title: 'Prayer Time', body: '7', id: 17);

        if (currentPrayerTime != null) {
          bool isScheduled = await currentPrayerTime.scheduleNotifications();
          log('isScheduled 1: $isScheduled');

          // await NotificationService()
          //     .showNotification(title: 'Prayer Time', body: '8', id: 18);
          if (!isScheduled) {

            // await NotificationService()
            //     .showNotification(title: 'Prayer Time', body: '9', id: 19);

            log('before getting Next Day');
            PrayerTime currentPrayerTime = prayerTimes.firstWhere(
                (PrayerTime prayerTime) =>
                    prayerTime.date!.readable == nextDayDateForPT);
            log('after getting Next Day');

            isScheduled = await currentPrayerTime.scheduleNotifications();
            log('isScheduled 2: $isScheduled');

            // await NotificationService()
            //     .showNotification(title: 'Prayer Time', body: '11', id: 111);
          }

          // await NotificationService()
          //     .showNotification(title: 'Prayer Time', body: '10', id: 100);

        }
        // await NotificationService()
        //     .showNotification(title: 'Prayer Time', body: task, id: 200);

        // if (task == 'init2') {
          Workmanager().registerOneOffTask(
            "init1",
            "init1",
            initialDelay: Duration(
                hours: 3// firstDailySchedule.millisecondsSinceEpoch -
                    //now.millisecondsSinceEpoch
                ),
            constraints: Constraints(
                networkType: NetworkType.not_required,
                requiresDeviceIdle: false,
                requiresBatteryNotLow: false,
                requiresStorageNotLow: false),
            existingWorkPolicy: ExistingWorkPolicy.replace,
          );
        // }else{
          Workmanager().registerOneOffTask(
            "init2",
            "init2",
            initialDelay: Duration(
                hours: 6 //secondDailySchedule.millisecondsSinceEpoch -
                    //now.millisecondsSinceEpoch
                ),
            constraints: Constraints(
                networkType: NetworkType.not_required,
                requiresDeviceIdle: false,
                requiresBatteryNotLow: false,
                requiresStorageNotLow: false),
            existingWorkPolicy: ExistingWorkPolicy.replace,
          );

          Workmanager().registerOneOffTask(
            "init3",
            "init3",
            initialDelay: Duration(
                hours: 9 //secondDailySchedule.millisecondsSinceEpoch -
              //now.millisecondsSinceEpoch
            ),
            constraints: Constraints(
                networkType: NetworkType.not_required,
                requiresDeviceIdle: false,
                requiresBatteryNotLow: false,
                requiresStorageNotLow: false),
            existingWorkPolicy: ExistingWorkPolicy.replace,
          );

          Workmanager().registerOneOffTask(
            "init4",
            "init4",
            initialDelay: Duration(
                hours: 12 //secondDailySchedule.millisecondsSinceEpoch -
              //now.millisecondsSinceEpoch
            ),
            constraints: Constraints(
                networkType: NetworkType.not_required,
                requiresDeviceIdle: false,
                requiresBatteryNotLow: false,
                requiresStorageNotLow: false),
            existingWorkPolicy: ExistingWorkPolicy.replace,
          );
        // }
      }

      log('workMan taskName: $task');

      return Future.value(true);
    } catch (err) {
      log('quietError :${err.toString()}'); // Logger flutter package, prints error on the debug console
      throw Exception(err);
    }
  });
}

void main() async {
  await initHive();

  await WidgetsFlutterBinding.ensureInitialized();

  final NotificationAppLaunchDetails? notificationAppLaunchDetails = !kIsWeb &&
          Platform.isLinux
      ? null
      : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  String? initialRoute = HomePage.routeName;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload =
        notificationAppLaunchDetails!.notificationResponse?.payload;
    initialRoute = SecondPage.routeName;
  }

  _configureDidReceiveLocalNotificationSubject();
  _configureSelectNotificationSubject();

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
  final InitializationSettings initializationSettings = InitializationSettings(
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
  await _configureLocalTimeZone();

  Workmanager().cancelAll().then((value) async {
    // Workmanager()
    //     .initialize(callbackDispatcher, isInDebugMode: false)
    //     .then((value) async {

      runApp(MyApp());
    // });
  });
}

class HomePage {
  static var routeName;
}

initHive() async {
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

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LocalCubit()..getSavedLanguage()),
        BlocProvider(create: (contxt) => TimeFormatCubit()..getTimeFormat()),
        BlocProvider(create: (contxt) => ThemeModeCubit()..getSavedTheme()),
        BlocProvider(create: (contxt) => InternetBloc()..add(InitialEvent())),
      ],
      child: BlocBuilder<LocalCubit, ChangedLocalState>(
          builder: (context, localState) {
        return BlocBuilder<ThemeModeCubit, ThemeModeChangedState>(
          builder: (context, themeState) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: themeState.theme == 'light' ? lightTheme : darkTheme,
              // ),
              locale: localState.locale,
              supportedLocales: [
                Locale('en'),
                Locale('ar'),
              ],
              localizationsDelegates: [
                // LocalJsonLocalization.delegate,
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],

              title: 'Prayer Times',

              home: MyHomePage(),
            );
          },
        );
        // });
      }),
    );
  }
}
