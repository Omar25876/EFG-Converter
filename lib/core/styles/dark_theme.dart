import 'package:efg_converter/core/styles/colors.dart';
import 'package:efg_converter/core/styles/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DarkTheme {
  DarkTheme._();

  static ThemeData theme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Cairo',
    brightness: Brightness.dark,
    primaryColor: primary,
    scaffoldBackgroundColor: backgroundDark,
    colorScheme: ColorScheme.dark(
      primary: primaryLight,
      secondary: accent,
      surface: surfaceDark,
      error: error,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: textOnDark,
      onError: Colors.white,
      surfaceTint: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: inputDark,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        borderSide: BorderSide(color: primaryLight.withValues(alpha: 0.2), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        borderSide: const BorderSide(color: primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        borderSide: const BorderSide(color: error, width: 1.5),
      ),
      hintStyle: TextStyle(color: textMuted, fontSize: 14.sp),
      labelStyle: TextStyle(
        color: textOnDark.withValues(alpha: 0.7),
        fontSize: 14.sp,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        elevation: 0,
        textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: borderDark,
      thickness: 0.5,
    ),
    iconTheme: IconThemeData(color: textOnDark, size: 24.sp),
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceDark,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: textOnDark, size: 24.sp),
      titleTextStyle: TextStyle(
        color: textOnDark,
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        fontFamily: 'Cairo',
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surfaceDark,
      indicatorColor: primary.withValues(alpha: 0.25),
      labelTextStyle: WidgetStateProperty.all(
        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: textOnDark),
      ),
      iconTheme: WidgetStateProperty.all(
        IconThemeData(color: textOnDark, size: 24.sp),
      ),
    ),
    cardTheme: CardThemeData(
      color: surfaceVariantDark,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: const BorderSide(color: borderDark, width: 0.5),
      ),
    ),
  );
}