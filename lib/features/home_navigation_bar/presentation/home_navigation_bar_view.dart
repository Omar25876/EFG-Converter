import 'package:easy_localization/easy_localization.dart';
import 'package:efg_converter/core/styles/app_text_styles.dart';
import 'package:efg_converter/core/styles/colors.dart';
import 'package:efg_converter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomeNavigationBarView extends StatefulWidget {
  final Widget child;

  const HomeNavigationBarView({
    super.key,
    required this.child,
  });

  @override
  State<HomeNavigationBarView> createState() =>
      _HomeNavigationBarViewState();
}

class _HomeNavigationBarViewState
    extends State<HomeNavigationBarView>
    with SingleTickerProviderStateMixin {
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();

    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    if (location == AppRoutes.history) {
      return 0;
    }

    if (location == AppRoutes.settings) {
      return 2;
    }

    return 1;
  }

  void _onTabTap(int index) {
    _fabController.reset();

    switch (index) {
      case 0:
        context.go(AppRoutes.history);
        break;

      case 1:
        context.go(AppRoutes.converter);
        break;

      case 2:
        context.go(AppRoutes.settings);
        break;
    }

    _fabController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateSelectedIndex(context);

    return Scaffold(
      backgroundColor: bgDark,
      extendBody: true,
      body: widget.child,
      bottomNavigationBar: _buildNavBar(currentIndex),
    );
  }

  Widget _buildNavBar(int currentIndex) {
    return Container(
      decoration: BoxDecoration(
        color: bgSurface,
        border: const Border(
          top: BorderSide(
            color: border,
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64.h,
          child: Row(
            children: [
              Expanded(
                child: _SideNavItem(
                  icon: Icons.history_rounded,
                  label: tr('history'),
                  isSelected: currentIndex == 0,
                  onTap: () => _onTabTap(0),
                ),
              ),

              _CenterFab(
                isSelected: currentIndex == 1,
                controller: _fabController,
                onTap: () => _onTabTap(1),
              ),

              Expanded(
                child: _SideNavItem(
                  icon: Icons.tune_rounded,
                  label: tr('settings'),
                  isSelected: currentIndex == 2,
                  onTap: () => _onTabTap(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenterFab extends StatelessWidget {
  final bool isSelected;
  final AnimationController controller;
  final VoidCallback onTap;

  const _CenterFab({
    required this.isSelected,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scaleAnim = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 60.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: scaleAnim,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: isSelected ? 44.w : 40.w,
                height: isSelected ? 44.w : 40.w,
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? heroGradient
                      : LinearGradient(
                    colors: [
                      bgCard,
                      bgCard,
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? primary.withValues(alpha: 0)
                        : border,
                  ),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.5),
                      blurRadius: 18,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: accent.withValues(alpha: 0.25),
                      blurRadius: 30,
                      spreadRadius: 4,
                    ),
                  ]
                      : [],
                ),
                child: Icon(
                  Icons.currency_exchange_rounded,
                  color: isSelected
                      ? Colors.white
                      : textMuted,
                  size: isSelected ? 22.sp : 20.sp,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: AppTextStyles.caption.copyWith(
                color: isSelected
                    ? primaryLight
                    : textMuted,
                fontWeight: isSelected
                    ? FontWeight.w600
                    : FontWeight.normal,
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

class _SideNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SideNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 42.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: isSelected
                  ? accent.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              icon,
              color: isSelected
                  ? accent
                  : textMuted,
              size: 22.sp,
            ),
          ),
          SizedBox(height: 3.h),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: AppTextStyles.caption.copyWith(
              color: isSelected
                  ? accent
                  : textMuted,
              fontWeight: isSelected
                  ? FontWeight.w600
                  : FontWeight.normal,
              fontSize: 10.sp,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}