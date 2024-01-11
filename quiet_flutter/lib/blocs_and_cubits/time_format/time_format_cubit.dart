import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../shared_preferemces/time_format_helper.dart';

part 'time_format_state.dart';

class TimeFormatCubit extends Cubit<TimeFormatChangedState> {
  TimeFormatCubit() : super(TimeFormatChangedState(timeFormat: 12));

  Future<void> getTimeFormat() async {
    int? timeFormat = await TimeFormatHelper().getCachedTimeFormat();
    emit(TimeFormatChangedState(timeFormat: timeFormat));
  }

  Future<void> changedTimeFormat(int timeFormat) async {
    log('inCubit: ${timeFormat}');
    await TimeFormatHelper().cacheTimeFormat(timeFormat);
    emit(TimeFormatChangedState(timeFormat: timeFormat));
  }
}
