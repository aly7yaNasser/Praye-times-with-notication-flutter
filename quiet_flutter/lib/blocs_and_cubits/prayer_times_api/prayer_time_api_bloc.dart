import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../general/general_static.dart';
import '../../models/prayer_time.dart';
import '../../shared_preferemces/location_helper.dart';
part 'prayer_time_api_event.dart';
part 'prayer_time_api_state.dart';

class PrayerTimeApiBloc extends Bloc<PrayerTimeApiEvent, PrayerTimeApiState> {
  static const prayerTimeKey = 'PRYERTIMES';
  final String url_base = 'api.aladhan.com';
  late String city;
  late String country;
  late String Year;
  late Box prayerTimeBox;

  PrayerTimeApiBloc() : super(PrayerTimeApiInitial()) {
    on<PrayerTimeApiEvent>((event, emit) async {
      log('event: ${event.toString()}');
      if (event is GetPrayerTimesEvent) {
        GetPrayerTimesEvent currentEvent = event as GetPrayerTimesEvent;
        // List<String>? locationList = await LocationHelper()
        //     .getCachedCountryAndCity();
        // if (locationList != null) {
        // country = locationList[0];
        // city = locationList[1];
        // currentEvent.year;
        // country = 'Saudi Arabia';
        // city = 'Riyadh';

        PrayerTime? prayerTime = await getPrayerTimes(
            country: currentEvent.country,
            city: currentEvent.city,
            year: currentEvent.year);
        if (prayerTime != null) {
          log('prayerTimesAPI Date: ${prayerTime!.date!.readable}');
          emit(SuccessfulState(todayPrayerTime: prayerTime!));
          GeneralStatic.isPrayertimeShown = true;
        } else {
          log('prayerTimesAPI : null');
          emit(ErrorState());
        }
      }
      // }
    });
  }

  Future<PrayerTime?> getPrayerTimes(
      {required String country,
      required String city,
      required int year}) async {
    log('year: ${year}, country: ${country}, city: ${city}');
    try {
      var url = Uri.https(url_base, 'v1/calendarByCity/${year}',
          {'method': '4', 'country': country, 'city': city});
      log('url: ${url}');
      var response = await http.get(url);
      if (response != null) {
        log('response: ${response}');
      }
      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        // print('Response body: ${response.body}');

        Map<String, dynamic> months = jsonDecode(response.body)['data'];
        log('months count: ${months.length}');
        List<PrayerTime> list = [];
        List<dynamic> days;
        String currentDate = DateFormat('dd MMM yyyy').format(DateTime.now());
        int fullDayTimstamp = (1000 * 60 * 60 * 24);
        PrayerTime prayerTime = PrayerTime();
        bool foundToday = false;

        months.forEach((key, value) {
          // log('${key}:: ${value}');
          days = value as List;
          for (var day in days) {
            String prayerTimeDate = day['date']['readable'];
            // log('day : ${prayerTimeDate}, current day:${currentDate}');
            if (foundToday) {
              prayerTime = PrayerTime.fromJson(day["timings"]);
              prayerTime.date = Date.fromJson(day['date']);
              // log('added PrayerTime ${prayerTime.date!.readable}');

              list.add(prayerTime);
            } else if (prayerTimeDate == currentDate) {
              prayerTime = PrayerTime.fromJson(day["timings"]);
              prayerTime.date = Date.fromJson(day['date']);
              // log('added PrayerTime ${prayerTime.date!.readable}');

              list.add(prayerTime);
              foundToday = true;
            }
          }
        });
        // log('date: ${list[0].date!.gregorian!.weekday!.en!}');
        //
        // log('fajer: ${list[0].fajr}');
        // log('date: ${list[0].date!.hijri!.weekday!.ar!}');
        log('PtayerTimesCount: ${list.length}');
        prayerTimeBox = await Hive.openBox(prayerTimeKey);

        await prayerTimeBox.put(prayerTimeKey, list);
        return list[0];
      } else {
        log('reaspons : null');
        Fluttertoast.showToast(
            msg: "This is Center Short Toast",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      if (e.toString().contains('host')) {
        return null;
      }
      log('catch prayerTimeApiBloc:$e');
    }
    return null;
  }

  getTodayPrayerTime() async {}
}
