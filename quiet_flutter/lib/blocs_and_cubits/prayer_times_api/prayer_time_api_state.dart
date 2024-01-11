part of 'prayer_time_api_bloc.dart';

@immutable
abstract class PrayerTimeApiState {}

class PrayerTimeApiInitial extends PrayerTimeApiState {}

class ErrorState extends PrayerTimeApiState{
  final errorMessage = 'please connect to internet';
  ErrorState();

}

class SuccessfulState extends PrayerTimeApiState{
  late PrayerTime todayPrayerTime;
  SuccessfulState({required this.todayPrayerTime});
}

class GetPrayerTimesState extends PrayerTimeApiState{

}
