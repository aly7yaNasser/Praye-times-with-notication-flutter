part of 'locale_cubit.dart';


class ChangedLocalState {
  Locale? locale ;

  ChangedLocalState({required String? lang})  {
    if(lang == null) {
      List<String> supportedLocales = ['ar', 'en'];
      String? deviceLocale;
      Devicelocale.currentLocale.then((value) {
        deviceLocale = value;
        String? deviceLang = deviceLocale!.split('-')[0];
        log('deviceLang: ${deviceLang!}');
        this.locale = Locale(deviceLang);
      });

    }else{
      this.locale = Locale(lang);

    }
  }
}