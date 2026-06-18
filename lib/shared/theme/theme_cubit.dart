import 'package:efg_converter/core/storage/hive_storage.dart';
import 'package:efg_converter/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final HiveStorage _prefs;

  ThemeCubit(this._prefs) : super(ThemeState(themeMode: ThemeMode.light)) {
    _loadSaved();
  }

  void _loadSaved() {
    final saved = _prefs.read(StorageKeys.themeMode) as String?;
    final mode = saved == 'dark'
        ? ThemeMode.dark
        : saved == 'system'
        ? ThemeMode.system
        : ThemeMode.light;
    emit(ThemeState(themeMode: mode));
  }

  Future<void> setLight() async {
    await _prefs.write(StorageKeys.themeMode, 'light');
    emit(ThemeState(themeMode: ThemeMode.light));
  }

  Future<void> setDark() async {
    await _prefs.write(StorageKeys.themeMode, 'dark');
    emit(ThemeState(themeMode: ThemeMode.dark));
  }

  Future<void> setSystem() async {
    await _prefs.write(StorageKeys.themeMode, 'system');
    emit(ThemeState(themeMode: ThemeMode.system));
  }

  Future<void> toggle() async {
    if (state.themeMode == ThemeMode.dark) {
      await setLight();
    } else {
      await setDark();
    }
  }

  bool get isDark => state.themeMode == ThemeMode.dark;
}