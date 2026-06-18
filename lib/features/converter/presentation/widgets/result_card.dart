import 'package:easy_localization/easy_localization.dart';
import 'package:efg_converter/core/styles/app_colors.dart';
import 'package:efg_converter/core/styles/app_text_styles.dart';
import 'package:efg_converter/core/styles/colors.dart';
import 'package:efg_converter/core/utils/extentions/currency_extension.dart';
import 'package:efg_converter/features/converter/presentation/cubit/converter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({super.key, required this.state});

  final ConversionSuccess state;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeOutCubic,
      builder: (_, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 24 * (1 - value)),
          child: child,
        ),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2D0A1F), Color(0xFF1A0A2E)],
          ),
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(
            color: primary.withValues(alpha: 0.35),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.25),
              blurRadius: 32,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: accent.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative top-right glow
            Positioned(
              right: -20.w,
              top: -20.h,
              child: Container(
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      accent.withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  // "Converted Result" header pill
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20.r),
                      border:
                      Border.all(color: primary.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      tr('converted_result'),
                      style: AppTextStyles.caption.copyWith(
                        color: primaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Big result — CurrencyFormatter.formatAmount enforces en_US digits
                  ShaderMask(
                    shaderCallback: (b) => sunriseGradient.createShader(b),
                    child: Text(
                      CurrencyFormatter.formatAmount(state.result),
                      style: AppTextStyles.displayLarge.copyWith(
                        fontSize: 48.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  // Currency code
                  Text(
                    state.toCurrency,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: primaryLight.withValues(alpha: 0.8),
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Exchange rate pill — CurrencyFormatter.formatRate for up to 6 decimals
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 18.w, vertical: 11.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.compare_arrows_rounded,
                            color: accent, size: 16.sp),
                        SizedBox(width: 8.w),
                        Text(
                          '1 ${state.fromCurrency} = '
                              '${CurrencyFormatter.formatRate(state.rate)} '
                              '${state.toCurrency}',
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // Live / cached indicator dot
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                          state.isOffline ? c.warning_ : c.success_,
                          boxShadow: [
                            BoxShadow(
                              color: (state.isOffline
                                  ? c.warning_
                                  : c.success_)
                                  .withValues(alpha: 0.6),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 7.w),
                      Text(
                        state.isOffline
                            ? tr('using_cached_rates')
                            : tr('live_rate'),
                        style: AppTextStyles.caption.copyWith(
                          color:
                          state.isOffline ? c.warning_ : c.success_,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}