import 'package:efg_converter/core/styles/app_colors.dart';
import 'package:efg_converter/features/settings/presentation/widgets/about_section.dart';
import 'package:efg_converter/features/settings/presentation/widgets/appearance_section.dart';
import 'package:efg_converter/features/settings/presentation/widgets/language_section.dart';
import 'package:efg_converter/features/settings/presentation/widgets/settings_app_bar.dart';
import 'package:efg_converter/shared/language/lang_cubit.dart';
import 'package:efg_converter/shared/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<LangCubit, LangState>(
          builder: (context, langState) {
            return Scaffold(
              backgroundColor: c.scaffold,
              body: CustomScrollView(
                slivers: [
                  const SettingsAppBar(),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 32.h),
                      child: Column(
                        children: [
                          const AppearanceSection(),
                          SizedBox(height: 20.h),
                          const LanguageSection(),
                          SizedBox(height: 20.h),
                          const AboutSection(),
                          SizedBox(height: 80.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}