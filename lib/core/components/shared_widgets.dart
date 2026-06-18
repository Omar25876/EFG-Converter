import 'package:efg_converter/core/styles/app_text_styles.dart';
import 'package:efg_converter/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 56.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: onPressed == null
              ? null
              :  heroGradient,
          color: onPressed == null ?  textMuted : null,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: onPressed == null
              ? null
              : [
                  BoxShadow(
                    color:  primary.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(16.r),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 22.w,
                      height: 22.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: Colors.white, size: 20.sp),
                          SizedBox(width: 8.w),
                        ],
                        Text(
                          label,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Currency selector dropdown
class CurrencyDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final Map<String, String> currencies;
  final ValueChanged<String?> onChanged;

  const CurrencyDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.currencies,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelSmall),
        SizedBox(height: 6.h),
        Container(
          decoration: BoxDecoration(
            color:  bgInput,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color:  border),
          ),
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor:  bgCard,
              style: AppTextStyles.titleMedium,
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color:  textSecondary),
              items: currencies.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Row(
                    children: [
                      _FlagEmoji(code: entry.key),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key,
                              style: AppTextStyles.titleMedium.copyWith(
                                fontSize: 12.sp,
                              ),
                            ),
                            Text(
                              entry.value,
                              style: AppTextStyles.caption,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

/// Simple flag emoji from currency code
class _FlagEmoji extends StatelessWidget {
  final String code;
  const _FlagEmoji({required this.code});

  @override
  Widget build(BuildContext context) {
    // Map currency → country code
    const map = {
      'USD': 'US', 'EUR': 'EU', 'GBP': 'GB', 'JPY': 'JP',
      'AED': 'AE', 'SAR': 'SA', 'EGP': 'EG', 'CHF': 'CH',
      'CAD': 'CA', 'AUD': 'AU', 'CNY': 'CN', 'INR': 'IN',
      'TRY': 'TR', 'KWD': 'KW', 'QAR': 'QA', 'BHD': 'BH',
      'JOD': 'JO', 'MYR': 'MY', 'SEK': 'SE', 'NOK': 'NO',
    };
    final country = map[code] ?? code.substring(0, 2);
    final flag = country.toUpperCase().runes
        .map((r) => String.fromCharCode(r - 0x41 + 0x1F1E6))
        .join();
    return Container(
      width: 32.w,
      height: 24.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        color:  bgSurface,
      ),
      alignment: Alignment.center,
      child: Text(flag, style: TextStyle(fontSize: 16.sp)),
    );
  }
}

/// Error state widget
class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorStateWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:  error.withValues(alpha:0.1),
                border: Border.all(color:  error.withValues(alpha:0.3)),
              ),
              child: Icon(Icons.wifi_off_rounded, color:  error, size: 36.sp),
            ),
            SizedBox(height: 24.h),
            Text(
              message,
              style: AppTextStyles.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            AppButton(
              label: 'Retry',
              onPressed: onRetry,
              width: 160.w,
              icon: Icons.refresh_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

/// Offline banner
class OfflineBanner extends StatelessWidget {
  final String message;
  const OfflineBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      color:  warning.withValues(alpha:0.15),
      child: Row(
        children: [
          Icon(Icons.cloud_off_rounded, color:  warning, size: 16.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.caption.copyWith(color:  warning),
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading overlay
class LoadingWidget extends StatelessWidget {
  final String? message;
  const LoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 48.w,
            height: 48.h,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: const AlwaysStoppedAnimation( primary),
              backgroundColor:  primary.withValues(alpha:0.15),
            ),
          ),
          if (message != null) ...[
            SizedBox(height: 16.h),
            Text(message!, style: AppTextStyles.bodyMedium),
          ],
        ],
      ),
    );
  }
}

/// Glass card container
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const GlassCard({super.key, required this.child, this.padding, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient:  cardGradient,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color:  border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.r),
          child: Padding(
            padding: padding ?? EdgeInsets.all(20.w),
            child: child,
          ),
        ),
      ),
    );
  }
}
