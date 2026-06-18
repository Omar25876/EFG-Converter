import 'package:easy_localization/easy_localization.dart';
import 'package:efg_converter/core/styles/app_colors.dart';
import 'package:efg_converter/core/styles/app_text_styles.dart';
import 'package:efg_converter/core/styles/colors.dart';
import 'package:efg_converter/features/settings/presentation/widgets/settings_primitives.dart';
import 'package:efg_converter/shared/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppearanceSection extends StatelessWidget {
  const AppearanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return SettingsSection(
          icon: Icons.palette_rounded,
          iconColor: primary,
          label: tr('appearance'),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                ThemeOption(
                  label: tr('theme_light'),
                  icon: Icons.wb_sunny_rounded,
                  selected: state.themeMode == ThemeMode.light,
                  onTap: () => context.read<ThemeCubit>().setLight(),
                  previewBg: const Color(0xFFFFF8F0),
                  previewAccent: const Color(0xFFE0245E),
                ),
                SizedBox(width: 10.w),
                ThemeOption(
                  label: tr('theme_dark'),
                  icon: Icons.nightlight_rounded,
                  selected: state.themeMode == ThemeMode.dark,
                  onTap: () => context.read<ThemeCubit>().setDark(),
                  previewBg: const Color(0xFF0D0D14),
                  previewAccent: const Color(0xFFFF6B9D),
                ),
                SizedBox(width: 10.w),
                ThemeOption(
                  label: tr('theme_system'),
                  icon: Icons.phone_android_rounded,
                  selected: state.themeMode == ThemeMode.system,
                  onTap: () => context.read<ThemeCubit>().setSystem(),
                  previewBg: const Color(0xFFFFF8F0),
                  previewAccent: const Color(0xFF0D0D14),
                  splitPreview: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ThemeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final Color previewBg;
  final Color previewAccent;
  final bool splitPreview;

  const ThemeOption({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.previewBg,
    required this.previewAccent,
    this.splitPreview = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
          decoration: BoxDecoration(
            color: selected
                ? primary.withValues(alpha: 0.10)
                : c.cardBg,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: selected ? primary : c.border_,
              width: selected ? 1.5 : 0.7,
            ),
            boxShadow: selected
                ? [
              BoxShadow(
                color: primary.withValues(alpha: 0.20),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ]
                : [],
          ),
          child: Column(
            children: [
              // Mini phone mockup preview
              Container(
                width: 54.w,
                height: 42.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: selected
                        ? primary.withValues(alpha: 0.4)
                        : c.border_,
                    width: 1.2,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    // Status bar strip
                    Container(
                      height: 10.h,
                      color: const Color(0xFF0D0D14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 12.w,
                            height: 4.h,
                            margin: EdgeInsets.only(right: 3.w, top: 3.h),
                            decoration: BoxDecoration(
                              color: selected ? primary : Colors.white24,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Body
                    Expanded(
                      child: splitPreview
                          ? Row(
                        children: [
                          Expanded(child: Container(color: previewBg)),
                          Expanded(
                              child: Container(
                                  color: previewAccent)),
                        ],
                      )
                          : Container(
                        color: previewBg,
                        child: Center(
                          child: Container(
                            width: 28.w,
                            height: 5.h,
                            decoration: BoxDecoration(
                              color: previewAccent
                                  .withValues(alpha: 0.6),
                              borderRadius:
                              BorderRadius.circular(3.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              // Selected checkmark or icon
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: selected
                    ? Container(
                  key: const ValueKey('check'),
                  width: 22.w,
                  height: 22.h,
                  decoration: BoxDecoration(
                    gradient: heroGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_rounded,
                      color: Colors.white, size: 13.sp),
                )
                    : Icon(
                  key: const ValueKey('icon'),
                  icon,
                  size: 18.sp,
                  color: c.textSecondary_,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: selected ? primary : c.textSecondary_,
                  fontWeight:
                  selected ? FontWeight.w700 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}