import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiet_flutter/delegates/app_localization.dart';
import 'package:quiet_flutter/widgets/prayer_time_widget.dart';

import '../models/prayer_time.dart';


class PrayerTimesAndDateWidget extends StatelessWidget{
  final PrayerTime prayerTime;

  final String myLocationAR;
  final String myLocationEN;
  PrayerTimesAndDateWidget({ required this.prayerTime, required this.myLocationAR, required this.myLocationEN});

  @override
  Widget build(BuildContext context) {
    String currentLocaleCode =
    Localizations.localeOf(context).toString();

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return  Column(
      children: [
        Container(
          // height: 40,
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black
                      : Colors.grey
                      .withOpacity(0.5),
                  spreadRadius: 0.5,
                  blurRadius: 7,
                  offset: const Offset(1,
                      1), // changes position of shadow
                ),
              ],
              color: isDark
                  ? Colors.grey.shade900
                  : Colors.white,
            ),
    child:
            Column(
      children: [

        Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: currentLocaleCode ==
                    'ar'
                    ? Text(prayerTime
                    .date!
                    .hijri!
                    .weekday!
                    .ar!)
                    : Text(prayerTime
                    .date!
                    .gregorian!
                    .weekday!
                    .en!
    ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(prayerTime!
                    .date!
                    .hijri!
                    .date!),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(prayerTime!
                    .date!
                    .gregorian!
                    .date!),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                    'currentLocation'
                        .tr(context) +
                        ' :'),
              ),
            ),
            Expanded(
              child: Align(
                  alignment:
                  Alignment.center,
                  child: currentLocaleCode ==
                      'ar'
                      ? Text(myLocationAR)
                      : Text(myLocationEN)),
            ),
          ],
        ),
      ],
    ),
        ),
    SizedBox(
    height: 10,
    ),
    PrayerTimeWidget(
    name: 'fajr'.tr(context),
    time: prayerTime.fajr),
    SizedBox(
    height: 5,
    ),
    PrayerTimeWidget(
    name: 'sunrise'.tr(context),
    time: prayerTime.sunrise),
    SizedBox(
    height: 5,
    ),
    PrayerTimeWidget(
    name: 'dhuhr'.tr(context),
    time: prayerTime.dhuhr),
    SizedBox(
    height: 5,
    ),
    PrayerTimeWidget(
    name: 'asr'.tr(context),
    time: prayerTime.asr),
    SizedBox(
    height: 5,
    ),
    PrayerTimeWidget(
    name: 'maghrib'.tr(context),
    time: prayerTime.maghrib),
    SizedBox(
    height: 5,
    ),
    PrayerTimeWidget(
    name: 'isha'.tr(context),
    time: prayerTime.isha),
    ],
    );

  }
  
}