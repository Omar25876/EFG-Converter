import 'package:efg_converter/core/components/shared_widgets.dart';
import 'package:efg_converter/core/styles/app_colors.dart';
import 'package:efg_converter/core/styles/app_text_styles.dart';
import 'package:efg_converter/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsSection extends StatelessWidget {
  final String label;
  final Widget child;
  final IconData? icon;
  final Color? iconColor;

  const SettingsSection({
    super.key,
    required this.label,
    required this.child,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final resolvedIconColor = iconColor ?? primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header row with icon
        Padding(
          padding: EdgeInsets.only(left: 2.w, bottom: 10.h),
          child: Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: 28.w,
                  height: 28.h,
                  decoration: BoxDecoration(
                    color: resolvedIconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child:
                  Icon(icon, color: resolvedIconColor, size: 14.sp),
                ),
                SizedBox(width: 8.w),
              ],
              Text(
                label.toUpperCase(),
                style: AppTextStyles.caption.copyWith(
                  letterSpacing: 1.8,
                  color: c.textSecondary_,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        // Card
        Container(
          decoration: BoxDecoration(
            color: c.cardBg,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: c.border_, width: 0.8),
            boxShadow: [
              BoxShadow(
                color: resolvedIconColor.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: child,
          ),
        ),
      ],
    );
  }
}

class SettingsRow extends StatelessWidget {
  final IconData iconData;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const SettingsRow({
    super.key,
    required this.iconData,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.h,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(11.r),
              ),
              child: Icon(iconData, color: iconColor, size: 19.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: c.textPrimary_),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption
                        .copyWith(color: c.textSecondary_),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            trailing,
          ],
        ),
      ),
    );
  }
}

class SettingsDivider extends StatelessWidget {
  const SettingsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Divider(
      height: 0.5,
      thickness: 0.5,
      indent: 16.w,
      endIndent: 16.w,
      color: c.border_,
    );
  }
}

class SettingsToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: value,
      onChanged: onChanged,
      activeThumbColor: Colors.white,
      activeTrackColor: primary,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: Colors.grey.withValues(alpha: 0.3),
    );
  }
}