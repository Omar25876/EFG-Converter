import 'package:efg_converter/shared/language/lang_cubit.dart';
import 'package:efg_converter/shared/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension ThemeContextExt on BuildContext {
  ThemeCubit get themeCubit => read<ThemeCubit>();
  ThemeMode  get themeMode  => read<ThemeCubit>().state.themeMode;
  bool       get isDark     => read<ThemeCubit>().isDark;

  void toggleTheme()                   => read<ThemeCubit>().toggle();
  void setLightTheme()                 => read<ThemeCubit>().setLight();
  void setDarkTheme()                  => read<ThemeCubit>().setDark();
}

extension LangContextExt on BuildContext {
  LangCubit get langCubit  => read<LangCubit>();
  Locale    get appLocale   => read<LangCubit>().state.locale;
  bool      get isArabic    => read<LangCubit>().isArabic;
  bool      get isEnglish   => read<LangCubit>().isEnglish;

  void toggleLang()                    => read<LangCubit>().toggleLanguage(this);
  void setLang(String code)            => read<LangCubit>().changeLanguage(this, code);
}
