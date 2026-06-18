import 'package:easy_localization/easy_localization.dart';
import 'package:efg_converter/core/styles/app_colors.dart';
import 'package:efg_converter/core/styles/app_text_styles.dart';
import 'package:efg_converter/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConverterAppBar extends StatelessWidget {
  const ConverterAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return SliverAppBar(
      expandedHeight: 100.h,
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
            Positioned(
              left: -20.w,
              bottom: -20.h,
              child: Container(
                width: 140.w,
                height: 140.h,
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
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr('converter').toUpperCase(),
                      style: AppTextStyles.caption.copyWith(
                        letterSpacing: 2.5,
                        color: c.textSecondary_.withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    ShaderMask(
                      shaderCallback: (b) => heroGradient.createShader(b),
                      child: Text(
                        tr('live_exchange_rates'),
                        style: AppTextStyles.headlineLarge
                            .copyWith(color: Colors.white),
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