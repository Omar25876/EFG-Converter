import 'package:easy_localization/easy_localization.dart';
import 'package:efg_converter/core/styles/app_colors.dart';
import 'package:efg_converter/core/styles/app_text_styles.dart';
import 'package:efg_converter/core/styles/colors.dart';
import 'package:efg_converter/features/settings/presentation/widgets/settings_primitives.dart';
import 'package:efg_converter/routes/app_routes.dart';
import 'package:efg_converter/shared/language/lang_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LanguageSection extends StatelessWidget {
  const LanguageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(
      builder: (context, state) {
        final isAr = state.locale.languageCode == 'ar';

        return SettingsSection(
          icon: Icons.language_rounded,
          iconColor: primaryLight,
          label: tr('language'),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LangCard(
                  code: 'ar',
                  nativeName: 'العربية',
                  englishName: 'Arabic',
                  flag: '🇪🇬',
                  active: isAr,
                  onTap: () => _changeLang(context, 'ar', isAr),
                ),
                SizedBox(height: 10.h),
                _LangCard(
                  code: 'en',
                  nativeName: 'English',
                  englishName: 'English',
                  flag: '🇺🇸',
                  active: !isAr,
                  onTap: () => _changeLang(context, 'en', !isAr),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _changeLang(
      BuildContext context, String code, bool alreadyActive) async {
    if (alreadyActive) return;
    await context.read<LangCubit>().changeLanguage(context, code);
    if (context.mounted) {
      context.go(AppRoutes.splash);
    }
  }
}

class _LangCard extends StatelessWidget {
  final String code;
  final String nativeName;
  final String englishName;
  final String flag;
  final bool active;
  final VoidCallback onTap;

  const _LangCard({
    required this.code,
    required this.nativeName,
    required this.englishName,
    required this.flag,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: active
              ? primaryLight.withValues(alpha: 0.10)
              : c.inputBg,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: active
                ? primaryLight.withValues(alpha: 0.5)
                : c.border_,
            width: active ? 1.5 : 0.7,
          ),
          boxShadow: active
              ? [
            BoxShadow(
              color: primaryLight.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Row(
          children: [
            // Flag
            Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: active
                    ? primaryLight.withValues(alpha: 0.12)
                    : c.cardBg,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: active
                      ? primaryLight.withValues(alpha: 0.3)
                      : c.border_,
                ),
              ),
              child: Center(
                child: Text(flag, style: TextStyle(fontSize: 22.sp)),
              ),
            ),
            SizedBox(width: 14.w),
            // Names
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nativeName,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: active ? primaryLight : c.textPrimary_,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    englishName,
                    style: AppTextStyles.caption
                        .copyWith(color: c.textSecondary_),
                  ),
                ],
              ),
            ),
            // Active indicator
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: active
                  ? Container(
                key: const ValueKey('active'),
                width: 28.w,
                height: 28.h,
                decoration: BoxDecoration(
                  gradient: heroGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(Icons.check_rounded,
                    color: Colors.white, size: 14.sp),
              )
                  : Container(
                key: const ValueKey('inactive'),
                width: 28.w,
                height: 28.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: c.border_),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}