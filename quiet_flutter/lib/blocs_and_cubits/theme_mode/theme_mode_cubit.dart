import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/theme_data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiet_flutter/blocs_and_cubits/theme_mode/theme_mode_state.dart';

import '../../shared_preferemces/theme_data_helper.dart';


class ThemeModeCubit extends Cubit<ThemeModeChangedState> {
  ThemeModeCubit() : super(ThemeModeChangedState( theme: 'light'));

  changedTheme(String theme) async {
    log('theme: ${theme}');
  await themeHelper().cacheTheme(theme);
  emit(ThemeModeChangedState(theme: theme));
  }

  getSavedTheme() async {
    String theme = await themeHelper().getCachedTheme();
    // Fluttertoast.showToast(
    //     msg: "Theme : ${theme}",
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 16.0
    // );
    emit(ThemeModeChangedState(theme: theme));
  }
}
