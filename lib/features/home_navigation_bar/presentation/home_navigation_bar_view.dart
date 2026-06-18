import 'package:easy_localization/easy_localization.dart';
import 'package:efg_converter/core/styles/colors.dart';
import 'package:efg_converter/features/home_navigation_bar/presentation/widgets/nav_bar_fab.dart';
import 'package:efg_converter/features/home_navigation_bar/presentation/widgets/nav_bar_side_item.dart';
import 'package:efg_converter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomeNavigationBarView extends StatefulWidget {
  const HomeNavigationBarView({super.key, required this.child});

  final Widget child;

  @override
  State<HomeNavigationBarView> createState() =>
      _HomeNavigationBarViewState();
}

class _HomeNavigationBarViewState extends State<HomeNavigationBarView>
    with SingleTickerProviderStateMixin {
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  int _selectedIndex(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    if (path == AppRoutes.history) return 0;
    if (path == AppRoutes.settings) return 2;
    return 1;
  }

  void _onTap(int index) {
    HapticFeedback.lightImpact();
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
    final idx = _selectedIndex(context);

    return Scaffold(
      backgroundColor: bgDark,
      extendBody: true,
      body: widget.child,
      bottomNavigationBar: _NavBar(
        selectedIndex: idx,
        fabController: _fabController,
        onTap: _onTap,
      ),
    );
  }
}

// ── Extracted NavBar widget ───────────────────────────────────────────────────

class _NavBar extends StatelessWidget {
  const _NavBar({
    required this.selectedIndex,
    required this.fabController,
    required this.onTap,
  });

  final int selectedIndex;
  final AnimationController fabController;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: bgSurface,
        border: Border(
          top: BorderSide(color: borderDark, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64.h,
          child: Row(
            children: [
              Expanded(
                child: NavBarSideItem(
                  icon: Icons.history_rounded,
                  label: tr('history'),
                  isSelected: selectedIndex == 0,
                  onTap: () => onTap(0),
                ),
              ),
              NavBarFab(
                isSelected: selectedIndex == 1,
                controller: fabController,
                onTap: () => onTap(1),
              ),
              Expanded(
                child: NavBarSideItem(
                  icon: Icons.tune_rounded,
                  label: tr('settings'),
                  isSelected: selectedIndex == 2,
                  onTap: () => onTap(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}