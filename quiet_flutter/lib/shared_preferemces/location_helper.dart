
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
class LocationHelper {
  static const String myLocationARKey = "MYLOCATIONAR";
  static const String myLocationENKey = "MYLOCATIONEN";
  static const String countryKey = "COUNTRYKEY";
  static const String cityKey = "CITYKEY";

  Future<void> cacheLocation( String myLocationAR, String myLocationEN, String country, String city) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(myLocationARKey, myLocationAR);
    await sharedPreferences.setString(myLocationENKey, myLocationEN);
    await sharedPreferences.setString(countryKey, country);
    await sharedPreferences.setString(cityKey, city);
  }

  Future<String?> getCachedLocationAR() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final   myLocationAR = sharedPreferences.getString(myLocationARKey);
    if(myLocationAR != null) {
      return myLocationAR;
    }else {return null;}

  }

  Future<String?> getCachedLocationEN() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final   myLocationEN =  sharedPreferences.getString(myLocationENKey);
    log('Lang Helper: ${myLocationEN}');

    if(myLocationEN != null) {
      return myLocationEN;
    }else {return null;}

  }

  Future<List<String>?> getCachedCountryAndCity() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final   country = sharedPreferences.getString(countryKey);
    final   city = sharedPreferences.getString(cityKey);
    if(city != null && country != null) {
      List<String> list = [];
      list.add(country);
      list.add(city);
      return list;
    }else {return null;}

  }

  clearPrefrences() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }
}