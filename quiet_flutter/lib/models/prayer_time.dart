import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../main.dart';
import 'package:hive/hive.dart';

import '../shared_preferemces/locale_helper.dart';
part 'prayer_time.g.dart';

@HiveType(typeId: 1)
class PrayerTime {
  @HiveField(0)
  String? _fajr;
  @HiveField(1)
  String? _sunrise;
  @HiveField(2)
  String? _dhuhr;
  @HiveField(3)
  String? _asr;
  @HiveField(4)
  String? _sunset;
  @HiveField(5)
  String? _maghrib;
  @HiveField(6)
  String? _isha;
  @HiveField(7)
  String? _imsak;
  @HiveField(8)
  String? _midnight;
  @HiveField(9)
  String? _firstthird;
  @HiveField(10)
  String? _lastthird;
  @HiveField(11)
  Date? _date;

  PrayerTime(
      {String? fajr,
        String? sunrise,
        String? dhuhr,
        String? asr,
        String? sunset,
        String? maghrib,
        String? isha,
        String? imsak,
        String? midnight,
        String? firstthird,
        String? lastthird,
        Date? date}) {
    if (fajr != null) {
      this._fajr = fajr;
    }
    if (sunrise != null) {
      this._sunrise = sunrise;
    }
    if (dhuhr != null) {
      this._dhuhr = dhuhr;
    }
    if (asr != null) {
      this._asr = asr;
    }
    if (sunset != null) {
      this._sunset = sunset;
    }
    if (maghrib != null) {
      this._maghrib = maghrib;
    }
    if (isha != null) {
      this._isha = isha;
    }
    if (imsak != null) {
      this._imsak = imsak;
    }
    if (midnight != null) {
      this._midnight = midnight;
    }
    if (firstthird != null) {
      this._firstthird = firstthird;
    }
    if (lastthird != null) {
      this._lastthird = lastthird;
    }
    if (date != null) {
      this._date = date;
    }
  }

  String? get fajr => _fajr;
  set fajr(String? fajr) => _fajr = fajr;
  String? get sunrise => _sunrise;
  set sunrise(String? sunrise) => _sunrise = sunrise;
  String? get dhuhr => _dhuhr;
  set dhuhr(String? dhuhr) => _dhuhr = dhuhr;
  String? get asr => _asr;
  set asr(String? asr) => _asr = asr;
  String? get sunset => _sunset;
  set sunset(String? sunset) => _sunset = sunset;
  String? get maghrib => _maghrib;
  set maghrib(String? maghrib) => _maghrib = maghrib;
  String? get isha => _isha;
  set isha(String? isha) => _isha = isha;
  String? get imsak => _imsak;
  set imsak(String? imsak) => _imsak = imsak;
  String? get midnight => _midnight;
  set midnight(String? midnight) => _midnight = midnight;
  String? get firstthird => _firstthird;
  set firstthird(String? firstthird) => _firstthird = firstthird;
  String? get lastthird => _lastthird;
  set lastthird(String? lastthird) => _lastthird = lastthird;
  Date? get date => _date;
  set date(Date? date) => _date = date;

  PrayerTime.fromJson(Map<String, dynamic> json) {
    _fajr = json['Fajr'].toString().split(' ')[0];
    _sunrise = json['Sunrise'].toString().split(' ')[0];
    _dhuhr = json['Dhuhr'].toString().split(' ')[0];
    _asr = json['Asr'].toString().split(' ')[0];
    _sunset = json['Sunset'].toString().split(' ')[0];
    _maghrib = json['Maghrib'].toString().split(' ')[0];
    _isha = json['Isha'].toString().split(' ')[0];
    _imsak = json['Imsak'].toString().split(' ')[0];
    _midnight = json['Midnight'].toString().split(' ')[0];
    _firstthird = json['Firstthird'].toString().split(' ')[0];
    _lastthird = json['Lastthird'].toString().split(' ')[0];
    _date = json['date'] != null ? new Date.fromJson(json['date']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Fajr'] = this._fajr;
    data['Sunrise'] = this._sunrise;
    data['Dhuhr'] = this._dhuhr;
    data['Asr'] = this._asr;
    data['Sunset'] = this._sunset;
    data['Maghrib'] = this._maghrib;
    data['Isha'] = this._isha;
    data['Imsak'] = this._imsak;
    data['Midnight'] = this._midnight;
    data['Firstthird'] = this._firstthird;
    data['Lastthird'] = this._lastthird;
    if (this._date != null) {
      data['date'] = this._date!.toJson();
    }
    return data;
  }

  Future<bool> scheduleNotifications ()async {
    log('schedule 1');

    await _configureLocalTimeZone();
    log('schedule 2');

    // await flutterLocalNotificationsPlugin.show(2, 'title', 'body',
    //     const NotificationDetails(
    //       android: AndroidNotificationDetails(
    //           'alarm_clock_channel', 'Alarm Clock Channel',
    //           channelDescription: 'Alarm Clock Notification',
    //           sound: RawResourceAndroidNotificationSound('prayer_time_norify_sound'),
    //           importance: Importance.max,
    //           priority: Priority.max),),
    // );
    // await _zonedScheduleNotification();
    // await _zonedScheduleAlarmClockNotification(
    //     flutterLocalNotificationsPlugin,2);
    // await _zonedScheduleAlarmClockNotification(
    //     flutterLocalNotificationsPlugin, 7);
    bool returnValue = false;
    int currentTimeStamp = DateTime.now().millisecondsSinceEpoch;// - (1000*60*60*15);

    // await _showNotificationWithCustomTimestamp(currentTimeStamp+ (1000 * 60 *50));

    log('CurrentMill for ${date!.readable}: ${currentTimeStamp}');
    int ishaTimestampe = getTimeStampe(isha!) - currentTimeStamp;
    int maghribTimestampe = getTimeStampe(maghrib!) - currentTimeStamp;
    int asrTimestampe = getTimeStampe(asr!) - currentTimeStamp;
    int dhuhrTimestampe = getTimeStampe(dhuhr!) - currentTimeStamp;
    int fajrTimestampe = getTimeStampe(fajr!) - currentTimeStamp;

    log('ishaTimestampe: ${ishaTimestampe}');
    log('maghribTimestampe: ${maghribTimestampe}');
    log('asrTimestampe: ${asrTimestampe}');
    log('dhuhrTimestampe: ${dhuhrTimestampe}');
    log('fajrTimestampe: ${fajrTimestampe}');
    log('schedule 3');

    List<int> prayertimes = [ishaTimestampe, maghribTimestampe,asrTimestampe,dhuhrTimestampe,fajrTimestampe];
    log('schedule 4');

    // await _zonedScheduleAlarmClockNotification(
    //     flutterLocalNotificationsPlugin, 60000,6);

    // await _zonedScheduleAlarmClockNotification(
    //     flutterLocalNotificationsPlugin, 60000 * 7,7);
    int i = 0;
    while( i < prayertimes.length && 0 < prayertimes[i] ){
      log('loop: ${i}');
      await _zonedScheduleAlarmClockNotification(
          flutterLocalNotificationsPlugin, prayertimes[i],i);

      log('temp: ${prayertimes[i]}');
      i++;
      returnValue = true;
    }
    log('schedule 5');

    return returnValue;
  }
  Future<void> _zonedScheduleNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description',
              // sound: RawResourceAndroidNotificationSound('prayer_time_norify_sound'),
            ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation
            .absoluteTime);
  }
  Future<void> _zonedScheduleAlarmClockNotification(
       FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      int milliSeconds,
      int id
      ) async {
    log('tz zone: ${tz.local.currentTimeZone}');
    log('tz city: ${tz.local.name}');
    log('tz duration: ${tz.TZDateTime.now(tz.local).add( Duration(milliseconds: milliSeconds))}');

    String lang = await LocaleHelper().getCachedLanguageCode();
      String body = lang == 'en' ? 'Allah akbar' : 'ألله أكبر';
      String title = lang == 'en' ? 'Prayer Times' : 'أوقات الصلاة';

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.now(tz.local).add( Duration(milliseconds: milliSeconds)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'alarm_clock_channel', 'Alarm Clock Channel',
                channelDescription: 'Alarm Clock Notification',
        sound: RawResourceAndroidNotificationSound('prayer_time_norify_sound'),
        importance: Importance.max,
      priority: Priority.max),),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> _configureLocalTimeZone() async {
    log('tz init');
    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }

  Future<int?> getNextPrayerTime ()async {
    int currentTimeStamp = DateTime.now().millisecondsSinceEpoch;// - (1000*60*60*15);
    log('CurrentMill for ${date!.readable}: ${currentTimeStamp}');
    int ishaTimestampe = getTimeStampe(isha!);
    int maghribTimestampe = getTimeStampe(maghrib!);
    int asrTimestampe = getTimeStampe(asr!);
    int dhuhrTimestampe = getTimeStampe(dhuhr!);
    int fajrTimestampe = getTimeStampe(fajr!);

    log('ishaTimestampe: ${ishaTimestampe}');
    log('maghribTimestampe: ${maghribTimestampe}');
    log('asrTimestampe: ${asrTimestampe}');
    log('dhuhrTimestampe: ${dhuhrTimestampe}');
    log('fajrTimestampe: ${fajrTimestampe}');

    List<int> prayertimes = [ishaTimestampe, maghribTimestampe,asrTimestampe,dhuhrTimestampe,fajrTimestampe];

    int i = 0;
    while( i < prayertimes.length && currentTimeStamp < prayertimes[i] ){
log('loop: ${i}');


log('temp: ${prayertimes[i]}');
i++;
    }
    i = i-1;
    if (i >= 0 && i <= 4){
      log('nextPT: not null');
      return prayertimes[i];
    }else {
      log('nextPT:  null');

      return null;
    }
  }

  int getTimeStampe(String time){

    List<String> hourAndMin=[];
    hourAndMin = isha!.split(':');
    // hour = int.parse(hourAndMin[0]);
    // min = int.parse(hourAndMin[1]);
    String currentMonth = date!.gregorian!.month!._number!< 10 ? '0'+date!.gregorian!.month!._number!.toString() : date!.gregorian!.month!._number.toString();

    // String dateReadable = date!.gregorian!.year!+'-'+date!.gregorian!.month!._number.toString()+'-'+ date!.gregorian!.day!;
    String dateReadable = date!.gregorian!.year!+'-'+currentMonth+'-'+ date!.gregorian!.day!;
    log('getTimeStampe: ${dateReadable} '+ time+':00');
    // DateTime dateTime = DateTime.parse(dateReadable+' '+ time+':00');
    DateTime dateTime = DateTime.parse('$dateReadable $time:00');
    log('getTimeStampe DateTime: ${dateTime.year}/${dateTime.month}/${dateTime.day} ${dateTime.hour}:${dateTime.minute}');


    return dateTime.millisecondsSinceEpoch;
  }
}
@HiveType(typeId: 2)
class Date {
  @HiveField(0)
  String? _readable;
  @HiveField(1)
  String? _timestamp;
  @HiveField(2)
  Gregorian? _gregorian;
  @HiveField(3)
  Hijri? _hijri;

  Date(
      {String? readable,
        String? timestamp,
        Gregorian? gregorian,
        Hijri? hijri}) {
    if (readable != null) {
      this._readable = readable;
    }
    if (timestamp != null) {
      this._timestamp = timestamp;
    }
    if (gregorian != null) {
      this._gregorian = gregorian;
    }
    if (hijri != null) {
      this._hijri = hijri;
    }
  }

  String? get readable => _readable;
  set readable(String? readable) => _readable = readable;
  String? get timestamp => _timestamp;
  set timestamp(String? timestamp) => _timestamp = timestamp;
  Gregorian? get gregorian => _gregorian;
  set gregorian(Gregorian? gregorian) => _gregorian = gregorian;
  Hijri? get hijri => _hijri;
  set hijri(Hijri? hijri) => _hijri = hijri;

  Date.fromJson(Map<String, dynamic> json) {
    _readable = json['readable'];
    _timestamp = json['timestamp'];
    _gregorian = json['gregorian'] != null
        ? new Gregorian.fromJson(json['gregorian'])
        : null;
    _hijri = json['hijri'] != null ? new Hijri.fromJson(json['hijri']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['readable'] = this._readable;
    data['timestamp'] = this._timestamp;
    if (this._gregorian != null) {
      data['gregorian'] = this._gregorian!.toJson();
    }
    if (this._hijri != null) {
      data['hijri'] = this._hijri!.toJson();
    }
    return data;
  }
}
@HiveType(typeId: 3)
class Gregorian {
  @HiveField(0)
  String? _date;
  @HiveField(1)
  String? _format;
  @HiveField(2)
  String? _day;
  @HiveField(3)
  Weekday? _weekday;
  @HiveField(4)
  Month? _month;
  @HiveField(5)
  String? _year;
  @HiveField(6)
  Designation? _designation;

  Gregorian(
      {String? date,
        String? format,
        String? day,
        Weekday? weekday,
        Month? month,
        String? year,
        Designation? designation}) {
    if (date != null) {
      this._date = date;
    }
    if (format != null) {
      this._format = format;
    }
    if (day != null) {
      this._day = day;
    }
    if (weekday != null) {
      this._weekday = weekday;
    }
    if (month != null) {
      this._month = month;
    }
    if (year != null) {
      this._year = year;
    }
    if (designation != null) {
      this._designation = designation;
    }
  }

  String? get date => _date;
  set date(String? date) => _date = date;
  String? get format => _format;
  set format(String? format) => _format = format;
  String? get day => _day;
  set day(String? day) => _day = day;
  Weekday? get weekday => _weekday;
  set weekday(Weekday? weekday) => _weekday = weekday;
  Month? get month => _month;
  set month(Month? month) => _month = month;
  String? get year => _year;
  set year(String? year) => _year = year;
  Designation? get designation => _designation;
  set designation(Designation? designation) => _designation = designation;

  Gregorian.fromJson(Map<String, dynamic> json) {
    _date = json['date'];
    _format = json['format'];
    _day = json['day'];
    _weekday =
    json['weekday'] != null ? new Weekday.fromJson(json['weekday']) : null;
    _month = json['month'] != null ? new Month.fromJson(json['month']) : null;
    _year = json['year'];
    _designation = json['designation'] != null
        ? new Designation.fromJson(json['designation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this._date;
    data['format'] = this._format;
    data['day'] = this._day;
    if (this._weekday != null) {
      data['weekday'] = this._weekday!.toJson();
    }
    if (this._month != null) {
      data['month'] = this._month!.toJson();
    }
    data['year'] = this._year;
    if (this._designation != null) {
      data['designation'] = this._designation!.toJson();
    }
    return data;
  }
}

@HiveType(typeId: 4)
class Designation {
  @HiveField(0)
  String? _abbreviated;
  @HiveField(1)
  String? _expanded;

  Designation({String? abbreviated, String? expanded}) {
    if (abbreviated != null) {
      this._abbreviated = abbreviated;
    }
    if (expanded != null) {
      this._expanded = expanded;
    }
  }

  String? get abbreviated => _abbreviated;
  set abbreviated(String? abbreviated) => _abbreviated = abbreviated;
  String? get expanded => _expanded;
  set expanded(String? expanded) => _expanded = expanded;

  Designation.fromJson(Map<String, dynamic> json) {
    _abbreviated = json['abbreviated'];
    _expanded = json['expanded'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['abbreviated'] = this._abbreviated;
    data['expanded'] = this._expanded;
    return data;
  }
}
@HiveType(typeId: 5)
class Hijri {
  @HiveField(0)
  String? _date;
  @HiveField(1)
  String? _format;
  @HiveField(2)
  String? _day;
  @HiveField(3)
  Weekday? _weekday;
  @HiveField(4)
  Month? _month;
  @HiveField(5)
  String? _year;

  Hijri(
      {String? date,
        String? format,
        String? day,
        Weekday? weekday,
        Month? month,
        String? year}) {
    if (date != null) {
      this._date = date;
    }
    if (format != null) {
      this._format = format;
    }
    if (day != null) {
      this._day = day;
    }
    if (weekday != null) {
      this._weekday = weekday;
    }
    if (month != null) {
      this._month = month;
    }
    if (year != null) {
      this._year = year;
    }
  }

  String? get date => _date;
  set date(String? date) => _date = date;
  String? get format => _format;
  set format(String? format) => _format = format;
  String? get day => _day;
  set day(String? day) => _day = day;
  Weekday? get weekday => _weekday;
  set weekday(Weekday? weekday) => _weekday = weekday;
  Month? get month => _month;
  set month(Month? month) => _month = month;
  String? get year => _year;
  set year(String? year) => _year = year;

  Hijri.fromJson(Map<String, dynamic> json) {
    _date = json['date'];
    _format = json['format'];
    _day = json['day'];
    _weekday =
    json['weekday'] != null ? new Weekday.fromJson(json['weekday']) : null;
    _month = json['month'] != null ? new Month.fromJson(json['month']) : null;
    _year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this._date;
    data['format'] = this._format;
    data['day'] = this._day;
    if (this._weekday != null) {
      data['weekday'] = this._weekday!.toJson();
    }
    if (this._month != null) {
      data['month'] = this._month!.toJson();
    }
    data['year'] = this._year;
    return data;
  }
}
@HiveType(typeId: 6)
class Weekday {
  @HiveField(0)
  String? _en;
  @HiveField(1)
  String? _ar;

  Weekday({String? en, String? ar}) {
    if (en != null) {
      this._en = en;
    }
    if (ar != null) {
      this._ar = ar;
    }
  }

  String? get en => _en;
  set en(String? en) => _en = en;
  String? get ar => _ar;
  set ar(String? ar) => _ar = ar;

  Weekday.fromJson(Map<String, dynamic> json) {
    _en = json['en'];
    _ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this._en;
    data['ar'] = this._ar;
    return data;
  }
}
@HiveType(typeId: 7)
class Month {
  @HiveField(0)
  int? _number;
  @HiveField(1)
  String? _en;
  @HiveField(2)
  String? _ar;

  Month({int? number, String? en, String? ar}) {
    if (number != null) {
      this._number = number;
    }
    if (en != null) {
      this._en = en;
    }
    if (ar != null) {
      this._ar = ar;
    }
  }

  int? get number => _number;
  set number(int? number) => _number = number;
  String? get en => _en;
  set en(String? en) => _en = en;
  String? get ar => _ar;
  set ar(String? ar) => _ar = ar;

  Month.fromJson(Map<String, dynamic> json) {
    _number = json['number'];
    _en = json['en'];
    _ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this._number;
    data['en'] = this._en;
    data['ar'] = this._ar;
    return data;
  }
}
