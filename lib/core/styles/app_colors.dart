import 'package:efg_converter/core/styles/colors.dart';
import 'package:flutter/material.dart';

class AppColors {
  final bool _dark;
  const AppColors(this._dark);

  // Scaffold / Page
  Color get scaffold  => _dark ? backgroundDark     : background;
  Color get surface_  => _dark ? surfaceDark        : surface;
  Color get cardBg    => _dark ? surfaceVariantDark  : surface;
  Color get inputBg   => _dark ? inputDark           : surfaceVariant;

  // Text
  Color get textPrimary_   => _dark ? textOnDark    : textDark;
  Color get textSecondary_ => _dark ? textMuted     : textSecondary;
  Color get textHint_      => _dark ? textMuted     : textHint;

  // Borders
  Color get border_ => _dark ? borderDark : borderLight;

  // Brand
  // In dark mode primaryLight (soft pink) reads better on dark bg.
  // in light mode the full vivid rose has enough contrast on cream.
  Color get primary_  => _dark ? primaryLight : primary;
  Color get accent_   => accent;   // amber gold — works on both
  Color get error_    => error;
  Color get success_  => success;
  Color get warning_  => warning;

  // Glow / Decorative
  // Orb tint used for radial gradient decorations
  Color get glowPrimary => _dark
      ? primary.withValues(alpha: 0.22)
      : primary.withValues(alpha: 0.10);

  Color get glowAccent => _dark
      ? accent.withValues(alpha: 0.18)
      : accent.withValues(alpha: 0.08);
}

extension AppColorsExt on BuildContext {
  AppColors get colors => AppColors(
    Theme.of(this).brightness == Brightness.dark,
  );
}