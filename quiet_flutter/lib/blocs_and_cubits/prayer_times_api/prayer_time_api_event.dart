part of 'prayer_time_api_bloc.dart';

@immutable
abstract class PrayerTimeApiEvent {}

class GetPrayerTimesEvent extends PrayerTimeApiEvent{
  String country,city;
  int year;
  GetPrayerTimesEvent({required this.country, required this.city, required this.year});
}

class ErrorEvent{}

class DisplayPrayerTiems extends PrayerTimeApiEvent{}


