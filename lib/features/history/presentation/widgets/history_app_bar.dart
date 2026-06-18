import 'package:easy_localization/easy_localization.dart';
import 'package:efg_converter/core/styles/app_colors.dart';
import 'package:efg_converter/core/styles/app_text_styles.dart';
import 'package:efg_converter/core/styles/colors.dart';
import 'package:efg_converter/features/history/presentation/cubit/history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryAppBar extends StatelessWidget {
  final HistoryCubit cubit;
  final HistoryState state;

  const HistoryAppBar({
    super.key,
    required this.cubit,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final loaded = state is HistoryLoaded ? state as HistoryLoaded : null;

    return SliverAppBar(
      expandedHeight: 180.h,
      floating: false,
      pinned: true,
      backgroundColor: c.scaffold,
      actions: [
        if (loaded != null && loaded.items.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: TextButton.icon(
              onPressed: () => _confirmClear(context),
              icon: Icon(Icons.delete_sweep_rounded,
                  color: c.error_, size: 18.sp),
              label: Text(
                tr('clear_all'),
                style: AppTextStyles.labelSmall.copyWith(color: c.error_),
              ),
            ),
          ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // ── Base gradient ──
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

            // ── Rose glow — top right ──
            Positioned(
              right: -40.w,
              top: -40.h,
              child: Container(
                width: 220.w,
                height: 220.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      primary.withValues(alpha: 0.16),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // ── Gold glow — bottom left ──
            Positioned(
              left: -30.w,
              bottom: -30.h,
              child: Container(
                width: 160.w,
                height: 160.h,
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

            // ── Title content ──
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr('history').toUpperCase(),
                      style: AppTextStyles.caption.copyWith(
                        letterSpacing: 2.5,
                        color: c.textSecondary_.withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    ShaderMask(
                      shaderCallback: (b) => heroGradient.createShader(b),
                      child: Text(
                        tr('conversions'),
                        style: AppTextStyles.headlineLarge
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    if (loaded != null) ...[
                      SizedBox(height: 4.h),
                      _CountPill(count: loaded.items.length),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmClear(BuildContext context) {
    final c = context.colors;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: c.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
          side: BorderSide(color: c.border_),
        ),
        title: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: c.error_.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.delete_sweep_rounded,
                  color: c.error_, size: 18.sp),
            ),
            SizedBox(width: 12.w),
            Text(tr('clear_history'), style: AppTextStyles.titleLarge),
          ],
        ),
        content: Text(
          tr('clear_history_confirm'),
          style: AppTextStyles.bodyMedium.copyWith(color: c.textSecondary_),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              tr('cancel'),
              style:
              AppTextStyles.labelLarge.copyWith(color: c.textSecondary_),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 8.w, bottom: 4.h),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                cubit.clearAll();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: c.error_,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              ),
              child: Text(
                tr('clear_all'),
                style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Count Pill ─────────────────────────────────────────────────────────────

class _CountPill extends StatelessWidget {
  final int count;
  const _CountPill({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: accent.withValues(alpha: 0.3)),
      ),
      child: Text(
        '$count ${tr('conversions').toLowerCase()}',
        style: AppTextStyles.caption.copyWith(
          color: accent,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}