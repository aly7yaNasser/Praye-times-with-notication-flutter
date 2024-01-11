part of 'location_bloc.dart';

@immutable
abstract class LocationState {
  late final String? myLocationAR, myLocationEN, country,city;


}

class LocationInitial extends LocationState {
  LocationInitial(){
  log('Log Init');

  }
}

class LocationChangedState extends LocationState{
  LocationChangedState( {required  newMyLocationAR, required  newMyLocationEN, required  newCountry, required  newCity}){
    myLocationEN = newMyLocationEN;
    myLocationAR = newMyLocationAR;
    country = newCountry;
    city = newCity;
    log('loc state const : myLocEN ${myLocationEN}');
  }
}

class LocationNotEnabledState extends LocationState{}
class LocationEnabledState extends LocationState{}

class LocationNotAllowedState extends LocationState{}
class LocationAllowedState extends LocationState{}
class LocationFoundDataState extends LocationState{

  final PrayerTime prayerTime;
  LocationFoundDataState({ required newMyLocationAR, required  newMyLocationEN, required newCountry, required newCity, required this.prayerTime}){
    myLocationEN = newMyLocationEN;
    myLocationAR = newMyLocationAR;
    country = newCountry;
    city = newCity;
  }
}

