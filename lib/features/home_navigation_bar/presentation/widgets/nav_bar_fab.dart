import 'package:easy_localization/easy_localization.dart';
import 'package:efg_converter/core/styles/app_text_styles.dart';
import 'package:efg_converter/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavBarFab extends StatelessWidget {
  const NavBarFab({
    super.key,
    required this.isSelected,
    required this.controller,
    required this.onTap,
  });

  final bool isSelected;
  final AnimationController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scaleAnim = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.elasticOut),
    );

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: scaleAnim,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                width: isSelected ? 44.w : 40.w,
                height: isSelected ? 44.w : 40.w,
                decoration: BoxDecoration(
                  gradient: isSelected ? heroGradient : null,
                  color: isSelected ? null : bgCard,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : borderDark,
                    width: 1,
                  ),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.45),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                    BoxShadow(
                      color: accent.withValues(alpha: 0.2),
                      blurRadius: 32,
                      spreadRadius: 4,
                    ),
                  ]
                      : [],
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.currency_exchange_rounded,
                    key: ValueKey(isSelected),
                    color: isSelected ? Colors.white : textMuted,
                    size: isSelected ? 24.sp : 21.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.h),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: AppTextStyles.caption.copyWith(
                color: isSelected ? primaryLight : textMuted,
                fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 10.sp,
              ),
              child: Text(tr('converter')),
            ),
          ],
        ),
      ),
    );
  }
}