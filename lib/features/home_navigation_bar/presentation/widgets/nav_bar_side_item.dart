import 'package:efg_converter/core/styles/app_text_styles.dart';
import 'package:efg_converter/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavBarSideItem extends StatelessWidget {
  const NavBarSideItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pill highlight + icon
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: 48.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: isSelected
                  ? accent.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Icon(
                icon,
                key: ValueKey(isSelected),
                color: isSelected ? accent : textMuted,
                size: 22.sp,
              ),
            ),
          ),
          SizedBox(height: 3.h),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: AppTextStyles.caption.copyWith(
              color: isSelected ? accent : textMuted,
              fontWeight:
              isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 10.sp,
            ),
            child: Text(label),
          ),
          // Bottom indicator
          SizedBox(height: 2.h),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            width: isSelected ? 18.w : 0,
            height: 3.h,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(3.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}