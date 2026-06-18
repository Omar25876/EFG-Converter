import 'package:efg_converter/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle displayLarge = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 48.sp,
    fontWeight: FontWeight.w800,
    color:  textPrimary,
    letterSpacing: -1.5,
    height: 1.1,
  );

  static TextStyle displayMedium = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 36.sp,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static TextStyle headlineLarge = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
    color:  textPrimary,
    height: 1.3,
  );

  static TextStyle headlineMedium = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
    color:  textPrimary,
    height: 1.3,
  );

  static TextStyle titleLarge = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color:  textPrimary,
    height: 1.4,
  );

  static TextStyle titleMedium = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color:  textPrimary,
    height: 1.4,
  );

  static TextStyle bodyLarge = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color:  textPrimary,
    height: 1.5,
  );

  static TextStyle bodyMedium = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color:  textSecondary,
    height: 1.5,
  );

  static TextStyle labelLarge = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color:  textPrimary,
    letterSpacing: 0.1,
  );

  static TextStyle labelSmall = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    color:  textMuted,
    letterSpacing: 0.5,
  );

  static TextStyle caption = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color:  textMuted,
    height: 1.4,
  );
}
