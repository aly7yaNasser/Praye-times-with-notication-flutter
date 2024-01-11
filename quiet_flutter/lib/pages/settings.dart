import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiet_flutter/blocs_and_cubits/notification/notify_cubit.dart';
import 'package:quiet_flutter/blocs_and_cubits/theme_mode/theme_mode_cubit.dart';
import 'package:quiet_flutter/blocs_and_cubits/theme_mode/theme_mode_state.dart';
import 'package:quiet_flutter/blocs_and_cubits/time_format/time_format_cubit.dart';
import 'package:quiet_flutter/delegates/app_localization.dart';
import 'package:quiet_flutter/services/notification_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workmanager/workmanager.dart';

import '../blocs_and_cubits/locale_cubit/locale_cubit.dart';
import '../main.dart';
import '../services/scheduler_service.dart';
import '../shared_preferemces/is_first_helper.dart';

class PaddedElevatedButton extends StatelessWidget {
  const PaddedElevatedButton({
    required this.buttonText,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
    child: ElevatedButton(
      onPressed: onPressed,
      child: Text(buttonText),
    ),
  );
}

  class SettingsPage extends StatelessWidget{
  BuildContext? context;


  Future<void> _checkPendingNotificationRequests() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
    await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return showDialog<void>(
      context: context!,
      builder: (BuildContext context) => AlertDialog(
        content: Text('${pendingNotificationRequests.length} pending notification '
            'requests'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    Fluttertoast.showToast(msg: 'msg');
    didReceiveLocalNotificationStream.close();
    selectNotificationStream.close();
    IsFirstHelper().cacheIsFirst(false);
    log('isFirst onDispose Settings: ${IsFirstHelper().getCachedIsFirst()}');

  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    // NotificationService().showNotification(title: 'Prayer Time', body: 'Allah akbar');
    List<String> notifItems = [
      NotifyChangedState.NOTIFY_ENABLED,
      NotifyChangedState.NOTIFY_DISABLED
    ];

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    TextTheme textTheme = Theme.of(context).textTheme;
    TextEditingController _durationText = TextEditingController();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (contxt) => NotifyCubit()..getSavedNotifyValue()),
        //
      ],
      child: BlocBuilder<LocalCubit, ChangedLocalState>(
          builder: (context, localState) {
        return Scaffold(
          appBar: AppBar(
            title: Text("settings".tr(context)),
          ),
          body: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
                child: Column(
                  children: [
                    PaddedElevatedButton(
                      buttonText: 'Check pending notifications',
                      onPressed: () async {
                        await _checkPendingNotificationRequests();
                      },
                    ),
                    Container(
                      child: Container(
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withOpacity(0.5)
                                  : Colors.grey.withOpacity(0.6),
                              spreadRadius: 0.5,
                              blurRadius: 7,
                              offset: const Offset(
                                  1, 1), // changes position of shadow
                            ),
                          ],
                          color: isDark ? Colors.grey.shade900 : Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "language".tr(context),
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: BlocConsumer<LocalCubit,
                                            ChangedLocalState>(
                                          listener: (context, state) {
                                            Navigator.of(context).pop();
                                          },
                                          builder: (context, state) {
                                            return DropdownButton(
                                                underline: SizedBox(),
                                                value:
                                                    state.locale!.languageCode,
                                                items: ['Arabic', 'English']
                                                    .map((String items) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: items
                                                        .substring(0, 2)
                                                        .toLowerCase(),
                                                    child:
                                                        Text(items.tr(context)),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  if (newValue != null) {
                                                    BlocProvider.of<LocalCubit>(
                                                            context)
                                                        .changedLanguage(
                                                            newValue);
                                                  }
                                                });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(color: Colors.deepOrange, height: 10),
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "timeFormat".tr(context),
                                            style: TextStyle(fontSize: 18),
                                          )),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: BlocConsumer<TimeFormatCubit,
                                            TimeFormatChangedState>(
                                          listener: (context, state) {
                                            Navigator.of(context).pop();
                                          },
                                          builder: (context, state) {
                                            return DropdownButton(
                                                underline: SizedBox(),
                                                value: state.timeFormat,
                                                items:
                                                    [12, 24].map((int items) {
                                                  return DropdownMenuItem<int>(
                                                    value: items,
                                                    child: Text(items
                                                            .toString() +
                                                        ' ' +
                                                        'hours'.tr(context)),
                                                  );
                                                }).toList(),
                                                onChanged: (int? newValue) {
                                                  if (newValue != null) {
                                                    BlocProvider.of<
                                                                TimeFormatCubit>(
                                                            context)
                                                        .changedTimeFormat(
                                                            newValue);
                                                  }
                                                });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(color: Colors.deepOrange, height: 10),
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "theme".tr(context),
                                            style: TextStyle(fontSize: 18),
                                          )),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: BlocConsumer<ThemeModeCubit,
                                            ThemeModeChangedState>(
                                          listener: (context, state) {
                                            Navigator.of(context).pop();
                                          },
                                          builder: (context, state) {
                                            return DropdownButton(
                                                underline: SizedBox(),
                                                value: state.theme,
                                                items: ['light', 'dark']
                                                    .map((String items) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: items,
                                                    child:
                                                        Text(items.tr(context)),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  if (newValue != null) {
                                                    BlocProvider.of<
                                                                ThemeModeCubit>(
                                                            context)
                                                        .changedTheme(newValue);
                                                  }
                                                });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(color: Colors.deepOrange, height: 10),
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "notification".tr(context),
                                            style: TextStyle(fontSize: 18),
                                          )),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: BlocConsumer<NotifyCubit,
                                            NotifyChangedState>(
                                          listener: (context, state) {
                                            // Navigator.of(context).pop();
                                          },
                                          builder: (context, state) {
                                            return DropdownButton(
                                                underline: SizedBox(),
                                                value: state.notifyOption,
                                                items: notifItems
                                                    .map((String items) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: items,
                                                    child:
                                                        Text(items.tr(context)),
                                                  );
                                                }).toList(),
                                                onChanged:
                                                    (String? newValue)  {
                                                  if (newValue != null) {
                                                     BlocProvider.of<
                                                                NotifyCubit>(
                                                            context)
                                                        .NotifyValueChanged(
                                                            newValue,context);
                                                  }
                                                });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withOpacity(0.5)
                                : Colors.grey.withOpacity(0.6),
                            spreadRadius: 0.5,
                            blurRadius: 7,
                            offset: const Offset(
                                1, 1), // changes position of shadow
                          ),
                        ],
                        color: isDark ? Colors.grey.shade900 : Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  Text(
                                    'about app'.tr(context),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'prayer times source'.tr(context),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                      child: Text(
                                        'aladhan.com',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 18),
                                      ),
                                      onTap: () {
                                        _launchURL();
                                      }),
                                  // TextField(controller: _durationText),
                                  // ElevatedButton(
                                  //
                                  //     onPressed: () {
                                  //       log('pressed');
                                  //       Fluttertoast.showToast(msg: 'pressed');
                                  //       Workmanager().registerOneOffTask(
                                  //         "2",
                                  //         "init",
                                  //         initialDelay: Duration(minutes: int.parse(_durationText.value.text)),
                                  //         constraints: Constraints(
                                  //             networkType: NetworkType.not_required,
                                  //             requiresBatteryNotLow: false,
                                  //             requiresStorageNotLow: false),
                                  //         existingWorkPolicy: ExistingWorkPolicy.replace,
                                  //         inputData: {'time':int.parse(_durationText.value.text)},
                                  //       );
                                  //     },
                                  //     child: const Text('run Task',
                                  //         style: TextStyle(fontSize: 18)))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  _launchURL() async {
    final Uri url = Uri.parse('https://aladhan.com');
    log('source url ${url.toString()}');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch ${url}');
    }
  }
}
