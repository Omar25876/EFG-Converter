import 'package:efg_converter/core/styles/colors.dart';
import 'package:efg_converter/core/styles/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LightTheme {
  LightTheme._();

  static ThemeData theme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Cairo',
    brightness: Brightness.light,
    primaryColor: primary,
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.light(
      primary: primary,
      secondary: accent,
      surface: surface,
      error: error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textDark,
      onError: Colors.white,
      surfaceTint: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceVariant,
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
        borderSide: BorderSide(color: primary.withValues(alpha: 0.15), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        borderSide: const BorderSide(color: borderFocus, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        borderSide: const BorderSide(color: error, width: 1.5),
      ),
      hintStyle: TextStyle(color: textHint, fontSize: 14.sp),
      labelStyle: TextStyle(color: textSecondary, fontSize: 14.sp),
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
      color: borderLight,
      thickness: 0.5,
    ),
    iconTheme: IconThemeData(color: textDark, size: 24.sp),
    appBarTheme: AppBarTheme(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: textDark, size: 24.sp),
      titleTextStyle: TextStyle(
        color: textDark,
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        fontFamily: 'Cairo',
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surface,
      indicatorColor: primary.withValues(alpha: 0.12),
      labelTextStyle: WidgetStateProperty.all(
        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: textPrimary),
      ),
      iconTheme: WidgetStateProperty.all(
        IconThemeData(color: textDark, size: 24.sp),
      ),
    ),
    cardTheme: CardThemeData(
      color: surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: const BorderSide(color: borderLight, width: 0.5),
      ),
    ),
  );
}