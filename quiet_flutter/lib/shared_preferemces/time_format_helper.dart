import 'package:shared_preferences/shared_preferences.dart';

class TimeFormatHelper {
  static const String timeFormatKey = "TIMEFORMAT";
  Future<void> cacheTimeFormat(int timeFormat) async {
    // print('LangCode: ${timeFormat}');
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt(timeFormatKey, timeFormat);
  }

  Future<int> getCachedTimeFormat() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final cachedTimeFormat = sharedPreferences.getInt(timeFormatKey);
    if (cachedTimeFormat != null) {
      return cachedTimeFormat;
    } else {
      return 12;
    }
  }
}