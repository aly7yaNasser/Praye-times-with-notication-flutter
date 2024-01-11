import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localization/localization.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quiet_flutter/blocs_and_cubits/Internet/internet_bloc.dart';
import 'package:quiet_flutter/blocs_and_cubits/location/location_bloc.dart';
import 'package:quiet_flutter/blocs_and_cubits/prayer_times_api/prayer_time_api_bloc.dart';
import 'package:quiet_flutter/pages/settings.dart';
import 'package:quiet_flutter/delegates/app_localization.dart';
import 'package:quiet_flutter/services/permession_service.dart';
import 'package:quiet_flutter/shared_preferemces/auto_start_helper.dart';
import 'package:quiet_flutter/shared_preferemces/is_first_helper.dart';
import 'package:quiet_flutter/themes_and_styles/styles_constants.dart';
import 'package:quiet_flutter/widgets/prayer_time_widget.dart';
import 'package:workmanager/workmanager.dart';

import '../blocs_and_cubits/notification/notify_cubit.dart';
import '../main.dart';
import '../models/prayer_time.dart';
import '../widgets/Prayer_times_and_date_widget.dart';
import '../widgets/spinner.dart';
import 'package:auto_start_flutter/auto_start_flutter.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => MainPage();
}

class MainPage extends State<MyHomePage> {
  bool isFirst = true;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final StreamController<
      ReceivedNotification> didReceiveLocalNotificationStream =
  StreamController<ReceivedNotification>.broadcast();

  final StreamController<String?> selectNotificationStream = StreamController<
      String?>.broadcast();

  static const MethodChannel platform = MethodChannel(
      'dexterx.dev/flutter_local_notifications_example');

  static const String portName = 'notification_send_port';

  @override
  initState() {
    super.initState();
    initialization();
  }

  //initializing the autoStart with the first build.
  Future<void> initAutoStart() async {
    try {
      //check auto-start availability.
      bool? test = await isAutoStartAvailable;
      print(test);
      //if available then navigate to auto-start setting page.
      if (test != null && test ) {
        String cashedAutoStart = await AutoStartHelper().getCachedAutoStart();
        log('autoStart: $cashedAutoStart');
        if (cashedAutoStart == AutoStartHelper.AUTOSTARTDISABLED) {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) =>
                AlertDialog(
                  content: Text('enableAutoStart'.tr(context)),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        getAutoStartPermission();
                        IsFirstHelper().cacheIsFirst(false);

                        log('isFirst onDispose Main: ${IsFirstHelper()
                            .getCachedIsFirst()}');

                        Navigator.of(context).pop();
                      },
                      child: Text('settings'.tr(context)),
                    ),
                    isFirst == false &&
                        cashedAutoStart == AutoStartHelper.AUTOSTARTDISABLED ?
                    TextButton(
                      onPressed: () {
                        AutoStartHelper().cacheAutoStart(
                            AutoStartHelper.AUTOSTARTENABLED);
                        Navigator.of(context).pop();
                      },
                      child: Text("don't show again".tr(context)),
                    )
                        : Text(''),
                  ],
                ),
          );
        }
      }
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
  }
  void initialization() async {
    Workmanager()
        .initialize(callbackDispatcher, isInDebugMode: false);
    isFirst = await IsFirstHelper().getCachedIsFirst();
    log('isFirst: $isFirst');
    initAutoStart();

    await _requestPermissions();

    FlutterNativeSplash.remove();
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) =>
            CupertinoAlertDialog(
              title: receivedNotification.title != null ? Text(
                  receivedNotification.title!) : null,
              content: receivedNotification.body != null ? Text(
                  receivedNotification.body!) : null,
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
    selectNotificationStream.stream.listen((String? payload) async {
      await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) => SecondPage(payload),
      ));
    });
  }

  @override
  void dispose() {
    didReceiveLocalNotificationStream.close();
    selectNotificationStream.close();

    super.dispose();
  }

  Future<void> _requestPermissions() async {
    await PermissionService().requestPermission(Permission.location);

    // });

  }

  @override
  Widget build(BuildContext context) {
    PrayerTime prayerTime = PrayerTime();
    bool isDark = Theme
        .of(context)
        .brightness == Brightness.dark;

    PrayerTimeTextStyle? prayerTimeTextStyle =
    Theme.of(context).extension<PrayerTimeTextStyle>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (contxt) =>
        LocationBloc()
          ..add(GetMyLocation())),
        BlocProvider(create: (contxt) => PrayerTimeApiBloc()),

      ],

      child: Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('appName'.tr(context)),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => SettingsPage()));
                },
                icon: Icon(Icons.settings))
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     BlocProvider.of<LocationBloc>(context).getLocation();
        //   },
        // ),
        body: BlocBuilder<InternetBloc, InternetState>(
            builder: (context, internetState) {
              log('internetState: ${internetState.toString()}');
              // return BlocBuilder<NotifyCubit, NotifyChangedState>(
              //   builder: (context, notifState) {
              return BlocBuilder<LocationBloc, LocationState>(
                  builder: (context, locationState) {
                    log('locationState running');
                    if (locationState is LocationInitial) {
                      log('locationState: Init');
                      return Center(child: SpinnerWidget(message: ''));
                    }
                    if (locationState is LocationNotEnabledState) {
                      log('locationState: LocationNotEnabledState');

                      return Center(
                        child: Container(
                          child: Column(
                            children: [
                              Icon(
                                Icons.location_disabled,
                                size: 100,
                                color: Colors.deepOrange,
                              ),
                              Text(
                                'Location Service not Enabled !'.tr(context),
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (locationState is LocationNotAllowedState) {
                      log('locationState: LocationNotAllowedState');

                      return Center(
                        child: Container(
                          child: Column(
                            children: [
                              Icon(
                                Icons.location_off_outlined,
                                size: 100,
                                color: Colors.deepOrange,
                              ),
                              Text(
                                'Location permission not allowed !'.tr(context),
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (locationState is LocationChangedState ||
                        locationState is LocationFoundDataState) {
                      String currentLocaleCode =
                      Localizations.localeOf(context).toString();
                      if (locationState is LocationChangedState) {
                        log('locationState: LocationChanged');
                        if (internetState is NotConnectedState) {
                          return Center(
                            child: Container(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.warning_amber_outlined,
                                    size: 100,
                                    color: Colors.deepOrange,
                                  ),
                                  Text(
                                    'Check Internet Connection !'.tr(context),
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      } else {
                        log('location Found Date');
                      }
                      log("myLocEN : ${locationState.myLocationEN}");
                      log('check location');
                      if (locationState.myLocationEN != null) {
                        log('current locale: ${Localizations.localeOf(
                            context)}');


                        if (isFirst) {
                          isFirst = false;
                          NotifyCubit().NotifyValueChanged(
                              NotifyChangedState.NOTIFY_ENABLED, null);
                        }

                        return Container(
                          // color: Colors.grey.shade50,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                                  child: BlocBuilder<PrayerTimeApiBloc,
                                      PrayerTimeApiState>(
                                      builder: (context, prayerTimeState) {
                                        if (locationState is LocationFoundDataState) {
                                          prayerTime = locationState.prayerTime;
                                        }
                                        if (prayerTime.date == null &&
                                            prayerTimeState is! SuccessfulState &&
                                            prayerTimeState is! ErrorState) {
                                          context.read<PrayerTimeApiBloc>().add(
                                              GetPrayerTimesEvent(
                                                  country: locationState
                                                      .country!,
                                                  city: locationState.city!,
                                                  year: prayerTime.date == null
                                                      ? DateTime
                                                      .now()
                                                      .year
                                                      : DateTime
                                                      .now()
                                                      .year + 1));
                                        } else
                                        if (prayerTimeState is SuccessfulState) {
                                          prayerTime =
                                              prayerTimeState.todayPrayerTime;
                                        }
                                        // log('main page : prayertime date ${prayerTime.date!.readable}');
                                        if (prayerTime.date != null) {
                                          return PrayerTimesAndDateWidget(
                                              prayerTime: prayerTime,
                                              myLocationAR: locationState
                                                  .myLocationAR!,
                                              myLocationEN: locationState
                                                  .myLocationEN!);
                                        } else {
                                          return Center(
                                            child: SpinnerWidget(message: ''),
                                          );
                                        }
                                      }),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Center(
                          child: Container(
                            child: Column(children: [
                              Icon(
                                Icons.warning_amber_outlined,
                                size: 100,
                                color: Colors.deepOrange,
                              ),
                              Text(
                                'error while getting your location!'.tr(
                                    context),
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyLarge,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepOrange),
                                  onPressed: () =>
                                      context.read<LocationBloc>().add(
                                          GetMyLocation()),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.refresh,
                                      ),
                                      Text(
                                        'try again'.tr(context),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        );
                      }
                    }
                    log('loc state not all');
                    return Center(child: SpinnerWidget(message: ''));
                  });
              // });
            }),
      ),
    );
  }
}
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


class SecondPage extends StatefulWidget {
  const SecondPage(
      this.payload, {
        Key? key,
      }) : super(key: key);

  static const String routeName = '/secondPage';

  final String? payload;

  @override
  State<StatefulWidget> createState() => SecondPageState();
}

class SecondPageState extends State<SecondPage> {
  String? _payload;

  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Second Screen'),
    ),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('payload ${_payload ?? ''}'),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Go back!'),
          ),
        ],
      ),
    ),
  );
}
