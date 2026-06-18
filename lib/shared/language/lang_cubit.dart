import 'package:easy_localization/easy_localization.dart';
import 'package:efg_converter/core/storage/hive_storage.dart';
import 'package:efg_converter/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;

part 'lang_state.dart';

class LangCubit extends Cubit<LangState> {
  final HiveStorage _prefs;

  static const _supportedLocales = [Locale('ar'), Locale('en')];

  LangCubit(this._prefs)
      : super(LangState(locale: _resolveInitial(_prefs)));

  static Locale _resolveInitial(HiveStorage prefs) {
    final saved = prefs.read(StorageKeys.language) as String?;
    if (saved == 'en') return const Locale('en');
    return const Locale('en');
  }

  Future<void> init(BuildContext context) async {
    await context.setLocale(state.locale);
  }

  Future<void> changeLanguage(BuildContext context, String langCode) async {
    final locale = _supportedLocales.firstWhere(
          (l) => l.languageCode == langCode,
      orElse: () => const Locale('en'),
    );
    await _prefs.write(StorageKeys.language, langCode);
    await context.setLocale(locale);
    emit(LangState(locale: locale));
  }

  Future<void> toggleLanguage(BuildContext context) async {
    final next = state.locale.languageCode == 'ar' ? 'en' : 'ar';
    await changeLanguage(context, next);
  }

  bool get isArabic => state.locale.languageCode == 'ar';
  bool get isEnglish => state.locale.languageCode == 'en';

  ui.TextDirection get textDirection =>
      isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr;
}