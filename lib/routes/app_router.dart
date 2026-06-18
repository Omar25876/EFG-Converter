import 'package:efg_converter/features/converter/presentation/views/converter_view.dart';
import 'package:efg_converter/features/history/presentation/views/history_view.dart';
import 'package:efg_converter/features/home_navigation_bar/presentation/home_navigation_bar_view.dart';
import 'package:efg_converter/features/settings/presentation/views/settings_view.dart';
import 'package:efg_converter/features/splash/presentation/splash_view.dart';
import 'package:efg_converter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellKey   = GlobalKey<NavigatorState>();

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashView(),
      ),

      // ShellRoute keeps HomeNavigationBarView alive across tab switches
      ShellRoute(
        navigatorKey: _shellKey,
        builder: (context, state, child) =>
            HomeNavigationBarView(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.converter,
            pageBuilder: (_, state) => _fadePage(
              key: state.pageKey,
              child: const ConverterView(),
            ),
          ),
          GoRoute(
            path: AppRoutes.history,
            pageBuilder: (_, state) => _fadePage(
              key: state.pageKey,
              child: const HistoryView(),
            ),
          ),
          GoRoute(
            path: AppRoutes.settings,
            pageBuilder: (_, state) => _fadePage(
              key: state.pageKey,
              child: const SettingsView(),
            ),
          ),
        ],
      ),
    ],

    errorBuilder: (_, state) => Scaffold(
      body: Center(child: Text('Route not found\n${state.uri}')),
    ),
  );

  static CustomTransitionPage<void> _fadePage({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 180),
      transitionsBuilder: (_, animation, __, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      ),
    );
  }
}