part of 'notify_cubit.dart';

class NotifyChangedState {
  static const NOTIFY_ENABLED = 'enable';
  static const NOTIFY_DISABLED = 'disable';
  String notifyOption;
  bool init = true;

  NotifyChangedState({required this.notifyOption, bool? init});


}
