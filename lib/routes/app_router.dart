import 'package:efg_converter/features/converter/presentation/views/converter_view.dart';
import 'package:efg_converter/features/history/presentation/views/history_view.dart';
import 'package:efg_converter/features/home_navigation_bar/presentation/home_navigation_bar_view.dart';
import 'package:efg_converter/features/settings/presentation/views/settings_view.dart';
import 'package:efg_converter/features/splash/presentation/splash_view.dart';
import 'package:efg_converter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> navigatorKey =
GlobalKey<NavigatorState>();

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.splash,

    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashView(),
      ),

      GoRoute(
        path: AppRoutes.converter,
        builder: (context, state) =>
        const HomeNavigationBarView(
          child: ConverterView(),
        ),
      ),

      GoRoute(
        path: AppRoutes.history,
        builder: (context, state) =>
        const HomeNavigationBarView(
          child: HistoryView(),
        ),
      ),

      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) =>
        const HomeNavigationBarView(
          child: SettingsView(),
        ),
      ),
    ],

    errorBuilder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('404'),
        ),
        body: Center(
          child: Text(
            'Route Not Found\n${state.uri}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    },
  );
}