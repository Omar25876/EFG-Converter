import 'package:easy_localization/easy_localization.dart';
import 'package:efg_converter/core/components/shared_widgets.dart';
import 'package:efg_converter/core/di/service_locator.dart';
import 'package:efg_converter/core/styles/app_colors.dart';
import 'package:efg_converter/core/styles/app_text_styles.dart';
import 'package:efg_converter/core/styles/colors.dart';
import 'package:efg_converter/features/history/domain/entities/conversion_history.dart';
import 'package:efg_converter/features/history/presentation/cubit/history_cubit.dart';
import 'package:efg_converter/features/history/presentation/widgets/history_app_bar.dart';
import 'package:efg_converter/features/history/presentation/widgets/history_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  late HistoryCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<HistoryCubit>()..loadHistory();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: c.scaffold,
            body: CustomScrollView(
              slivers: [
                HistoryAppBar(cubit: _cubit, state: state),
                if (state is HistoryLoading)
                  SliverFillRemaining(
                    child: LoadingWidget(message: tr('loading')),
                  )
                else if (state is HistoryError)
                  SliverFillRemaining(
                    child: ErrorStateWidget(
                      message: state.message,
                      onRetry: () => _cubit.loadHistory(),
                    ),
                  )
                else if (state is HistoryLoaded)
                    state.items.isEmpty
                        ? SliverFillRemaining(child: _EmptyHistory())
                        : _HistoryList(items: state.items, cubit: _cubit),


              ],
            ),
          );
        },
      ),
    );
  }
}


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

// ── Empty State ────────────────────────────────────────────────────────────

class _EmptyHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Glowing icon container
          Container(
            width: 110.w,
            height: 110.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  primary.withValues(alpha: 0.12),
                  Colors.transparent,
                ],
              ),
              border: Border.all(
                  color: primary.withValues(alpha: 0.25), width: 1.5),
            ),
            child: Icon(
              Icons.history_rounded,
              color: c.primary_,
              size: 46.sp,
            ),
          ),
          SizedBox(height: 28.h),
          ShaderMask(
            shaderCallback: (b) => heroGradient.createShader(b),
            child: Text(
              tr('no_history'),
              style:
              AppTextStyles.titleLarge.copyWith(color: Colors.white),
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 48.w),
            child: Text(
              tr('no_history_sub'),
              style: AppTextStyles.bodyMedium
                  .copyWith(color: c.textSecondary_),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// ── List ───────────────────────────────────────────────────────────────────

class _HistoryList extends StatelessWidget {
  final List<ConversionHistory> items;
  final HistoryCubit cubit;

  const _HistoryList({required this.items, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 100.h),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) => HistoryCard(
            item: items[index],
            index: index,
            onDelete: () => cubit.deleteItem(items[index].id),
          ),
          childCount: items.length,
        ),
      ),
    );
  }
}

