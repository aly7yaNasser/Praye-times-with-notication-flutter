import 'dart:developer';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:meta/meta.dart';

import '../../shared_preferemces/locale_helper.dart';

part 'locale_state.dart';


class LocalCubit extends Cubit<ChangedLocalState> {

  LocalCubit() : super(ChangedLocalState(lang:  null));

  Future<void> getSavedLanguage() async{
    final String cashedLanguage = await LocaleHelper().getCachedLanguageCode();
    print("mainCashedLang : ${cashedLanguage}");
    emit(ChangedLocalState(lang: cashedLanguage));
  }

  Future<void> changedLanguage(String languageCode)async {
    await LocaleHelper().cacheLanguageCode( languageCode);
    emit(ChangedLocalState(lang: languageCode));

  }
}