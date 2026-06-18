import 'package:easy_localization/easy_localization.dart';
import 'package:efg_converter/core/styles/app_colors.dart';
import 'package:efg_converter/core/styles/app_text_styles.dart';
import 'package:efg_converter/core/styles/colors.dart';
import 'package:efg_converter/core/utils/app_info_util.dart';
import 'package:efg_converter/features/settings/presentation/widgets/settings_primitives.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  late Future<String> _versionFuture;
  late Future<String> _appNameFuture;

  @override
  void initState() {
    super.initState();
    _versionFuture = AppInfoUtil.getAppVersion();
    _appNameFuture = AppInfoUtil.getAppName();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      icon: Icons.info_outline_rounded,
      iconColor: accent,
      label: tr('about'),
      child: Column(
        children: [
          FutureBuilder<String>(
            future: _versionFuture,
            builder: (context, snapshot) {
              return _AboutRow(
                icon: Icons.verified_rounded,
                iconColor: success,
                title: tr('version'),
                trailing: _VersionBadge(
                  label: snapshot.data ?? '0.0.0',
                ),
              );
            },
          ),
          const SettingsDivider(),
          FutureBuilder<String>(
            future: _appNameFuture,
            builder: (context, snapshot) {
              return _AboutRow(
                icon: Icons.code_rounded,
                iconColor: primaryLight,
                title: tr('developer'),
                trailing: Text(
                  snapshot.data ?? 'Loading...',
                  style: AppTextStyles.caption.copyWith(
                    color: primaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
          const SettingsDivider(),
          _AboutRow(
            icon: Icons.privacy_tip_outlined,
            iconColor: accent,
            title: tr('privacy_policy'),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14.sp,
            ),
            onTap: () {/* navigate */},
          ),
        ],
      ),
    );
  }
}
class _AboutRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;

  const _AboutRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 34.w,
              height: 34.h,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: iconColor, size: 17.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: c.textPrimary_),
              ),
            ),
            DefaultTextStyle(
              style: AppTextStyles.caption
                  .copyWith(color: c.textSecondary_),
              child: IconTheme(
                data: IconThemeData(
                    color: c.textSecondary_, size: 14.sp),
                child: trailing,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VersionBadge extends StatelessWidget {
  final String label;
  const _VersionBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: success.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: success.withValues(alpha: 0.35)),
      ),
      child: Text(
        'v$label',
        style: AppTextStyles.caption.copyWith(
          color: success,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}