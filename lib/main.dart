import 'package:easy_localization/easy_localization.dart';
import 'package:efg_converter/core/bloc_observer.dart';
import 'package:efg_converter/core/di/service_locator.dart';
import 'package:efg_converter/core/styles/dark_theme.dart';
import 'package:efg_converter/core/styles/light_theme.dart';
import 'package:efg_converter/routes/app_router.dart';
import 'package:efg_converter/shared/language/lang_cubit.dart';
import 'package:efg_converter/shared/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await setupServiceLocator();

  Bloc.observer = EFGBlocObserver();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      saveLocale: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(
            create: (_) => sl<ThemeCubit>(),
          ),
          BlocProvider<LangCubit>(
            create: (_) => sl<LangCubit>(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<LangCubit>().init(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<LangCubit, LangState>(
          builder: (context, langState) {
            return ScreenUtilInit(
              designSize: const Size(360, 690),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,

                  theme: LightTheme.theme,
                  darkTheme: DarkTheme.theme,
                  themeMode: themeState.themeMode,

                  locale: langState.locale,

                  localizationsDelegates:
                  context.localizationDelegates,

                  supportedLocales:
                  context.supportedLocales,

                  routerConfig: AppRouter.router,
                );

              },
            );
          },
        );
      },
    );
  }
}