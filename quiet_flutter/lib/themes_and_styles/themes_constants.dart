import 'package:flutter/material.dart';
import 'package:quiet_flutter/themes_and_styles/styles_constants.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  extensions: <ThemeExtension<dynamic>>{
    PrayerTimeTextStyle(
      fontSize: 40,
      textStyle: TextStyle(fontSize: 20),
    )
  },
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.deepOrange,
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    iconTheme: IconThemeData(color: Colors.white),
  ),
textTheme: TextTheme(
  bodySmall: TextStyle(
      fontSize: 18
  ),
  bodyLarge: TextStyle(
    fontSize:19,
    fontWeight: FontWeight.bold
  )
),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.deepOrange),
      foregroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
    )
  ),
  colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Colors.black,
      onPrimary: Colors.white,
      secondary: Colors.white,
      onSecondary: Colors.white,
      error: Colors.white,
      onError: Colors.white,
      background: Colors.white,
      onBackground: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
      primaryContainer: Colors.white,
      onSecondaryContainer: Colors.black,
      secondaryContainer: Colors.white,
      tertiaryContainer: Colors.white,
      onPrimaryContainer: Colors.white,
      onTertiaryContainer: Colors.white),
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme:  ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.white,
    onPrimary: Colors.deepOrange,
    secondary: Colors.white,
    onSecondary: Colors.white,
    error: Colors.white,
    onError: Colors.white,
    background: Colors.black,
    onBackground: Colors.white,
    surface: Colors.grey.shade900,
    onSurface: Colors.deepOrange,
    primaryContainer: Colors.black,
    onSecondaryContainer: Colors.white,
    secondaryContainer: Colors.white,
    tertiaryContainer: Colors.black,
    onPrimaryContainer: Colors.white,
    onTertiaryContainer: Colors.black),
  extensions: <ThemeExtension<dynamic>>{
    PrayerTimeTextStyle(
      fontSize: 40,
      textStyle: TextStyle(fontSize: 20, ),
    )
  },
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade800),
        foregroundColor: MaterialStateColor.resolveWith((states) => Colors.deepOrange.shade600),
      )
  ),
);
