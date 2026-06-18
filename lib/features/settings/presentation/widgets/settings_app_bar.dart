import 'package:easy_localization/easy_localization.dart';
import 'package:efg_converter/core/styles/app_colors.dart';
import 'package:efg_converter/core/styles/app_text_styles.dart';
import 'package:efg_converter/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsAppBar extends StatelessWidget {
  const SettingsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return SliverAppBar(
      expandedHeight: 200.h,
      floating: false,
      pinned: true,
      backgroundColor: c.scaffold,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Base gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    c.surface_.withValues(alpha: 0.98),
                    c.scaffold,
                  ],
                ),
              ),
            ),
            // Rose glow — top right
            Positioned(
              right: -50.w,
              top: -50.h,
              child: Container(
                width: 260.w,
                height: 260.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      primary.withValues(alpha: 0.18),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Gold glow — bottom left
            Positioned(
              left: -30.w,
              bottom: -20.h,
              child: Container(
                width: 180.w,
                height: 180.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      accent.withValues(alpha: 0.14),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Teal glow — top left corner
            Positioned(
              left: -20.w,
              top: -20.h,
              child: Container(
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      success.withValues(alpha: 0.10),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 28.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Settings icon badge
                    Container(
                      width: 44.w,
                      height: 44.h,
                      margin: EdgeInsets.only(bottom: 12.h),
                      decoration: BoxDecoration(
                        gradient: heroGradient,
                        borderRadius: BorderRadius.circular(14.r),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color: Colors.white,
                        size: 22.sp,
                      ),
                    ),
                    Text(
                      tr('preferences').toUpperCase(),
                      style: AppTextStyles.caption.copyWith(
                        letterSpacing: 2.5,
                        color: c.textSecondary_.withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    ShaderMask(
                      shaderCallback: (b) => heroGradient.createShader(b),
                      child: Text(
                        tr('settings'),
                        style: AppTextStyles.headlineLarge
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      tr('settings_sub'),
                      style: AppTextStyles.caption.copyWith(
                        color: c.textSecondary_.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}