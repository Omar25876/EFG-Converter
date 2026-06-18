import 'package:easy_localization/easy_localization.dart';
import 'package:efg_converter/core/styles/app_colors.dart';
import 'package:efg_converter/core/styles/app_text_styles.dart';
import 'package:efg_converter/core/styles/colors.dart';
import 'package:efg_converter/core/utils/extentions/currency_extension.dart';
import 'package:efg_converter/features/history/domain/entities/conversion_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryCard extends StatelessWidget {
  final ConversionHistory item;
  final int index;
  final VoidCallback onDelete;

  const HistoryCard({
    super.key,
    required this.item,
    required this.index,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    // Always render dates in English locale regardless of app language
    final dateStr = DateFormat('MMM d, y · HH:mm', 'en_US').format(item.convertedAt);

    // Alternate accent per row: even = rose, odd = gold
    final isRose = index.isEven;
    final tagGradient = isRose ? heroGradient : sunriseGradient;
    final tagColor = isRose ? primary : accent;
    final tagBg = isRose
        ? primary.withValues(alpha: 0.12)
        : accent.withValues(alpha: 0.12);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 60).clamp(0, 400)),
      curve: Curves.easeOutCubic,
      builder: (_, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 16 * (1 - value)),
          child: child,
        ),
      ),
      child: Dismissible(
        key: Key(item.id),
        direction: DismissDirection.endToStart,
        background: _DeleteBackground(c: c),
        onDismissed: (_) => onDelete(),
        child: _CardContent(
          item: item,
          tagGradient: tagGradient,
          tagColor: tagColor,
          tagBg: tagBg,
          dateStr: dateStr,
          onDelete: onDelete,
          c: c,
        ),
      ),
    );
  }
}

// ── Swipe-to-delete background ─────────────────────────────────────────────

class _DeleteBackground extends StatelessWidget {
  final dynamic c;
  const _DeleteBackground({required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.only(right: 24.w),
      decoration: BoxDecoration(
        color: c.error_.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: c.error_.withValues(alpha: 0.25)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delete_rounded, color: c.error_, size: 24.sp),
          SizedBox(height: 4.h),
          Text(
            tr('delete'),
            style: AppTextStyles.caption.copyWith(color: c.error_),
          ),
        ],
      ),
    );
  }
}

// ── Card content ───────────────────────────────────────────────────────────

class _CardContent extends StatelessWidget {
  final ConversionHistory item;
  final Gradient tagGradient;
  final Color tagColor;
  final Color tagBg;
  final String dateStr;
  final VoidCallback onDelete;
  final dynamic c;

  const _CardContent({
    required this.item,
    required this.tagGradient,
    required this.tagColor,
    required this.tagBg,
    required this.dateStr,
    required this.onDelete,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: c.border_, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: tagColor.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            _CurrencyAvatar(
              currencyCode: item.fromCurrency,
              gradient: tagGradient,
              tagColor: tagColor,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: _CardBody(
                item: item,
                tagColor: tagColor,
                tagBg: tagBg,
                dateStr: dateStr,
                c: c,
              ),
            ),
            _DeleteButton(onDelete: onDelete, c: c),
          ],
        ),
      ),
    );
  }
}

// ── Currency avatar (flag initials + gradient bg) ──────────────────────────

class _CurrencyAvatar extends StatelessWidget {
  final String currencyCode;
  final Gradient gradient;
  final Color tagColor;

  const _CurrencyAvatar({
    required this.currencyCode,
    required this.gradient,
    required this.tagColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54.w,
      height: 54.h,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: tagColor.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          // Use flag emoji if available, otherwise initials
          currencyCode.currencyFlag != '💱'
              ? currencyCode.currencyFlag
              : currencyCode.currencyInitials,
          style: currencyCode.currencyFlag != '💱'
              ? TextStyle(fontSize: 22.sp) // flag emoji — bigger
              : AppTextStyles.titleMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

// ── Card body (pair + amounts + date) ─────────────────────────────────────

class _CardBody extends StatelessWidget {
  final ConversionHistory item;
  final Color tagColor;
  final Color tagBg;
  final String dateStr;
  final dynamic c;

  const _CardBody({
    required this.item,
    required this.tagColor,
    required this.tagBg,
    required this.dateStr,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Currency pair ──
        _CurrencyPairRow(
          fromCurrency: item.fromCurrency,
          toCurrency: item.toCurrency,
          tagColor: tagColor,
          tagBg: tagBg,
          c: c,
        ),
        SizedBox(height: 5.h),

        // ── Amount → result (English numbers) ──
        RichText(
          text: TextSpan(
            style: AppTextStyles.bodyMedium.copyWith(color: c.textSecondary_),
            children: [
              TextSpan(text: CurrencyFormatter.formatAmount(item.amount)),
              TextSpan(
                text: '  →  ',
                style: TextStyle(color: tagColor),
              ),
              TextSpan(
                text: CurrencyFormatter.formatAmount(item.result),
                style: TextStyle(
                  color: c.textPrimary_,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),

        // ── Date ──
        Row(
          children: [
            Icon(Icons.access_time_rounded,
                size: 11.sp, color: c.textSecondary_),
            SizedBox(width: 4.w),
            Text(
              dateStr,
              style: AppTextStyles.caption.copyWith(color: c.textSecondary_),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Currency pair row: USD → EUR ───────────────────────────────────────────

class _CurrencyPairRow extends StatelessWidget {
  final String fromCurrency;
  final String toCurrency;
  final Color tagColor;
  final Color tagBg;
  final dynamic c;

  const _CurrencyPairRow({
    required this.fromCurrency,
    required this.toCurrency,
    required this.tagColor,
    required this.tagBg,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          fromCurrency,
          style: AppTextStyles.titleMedium.copyWith(color: c.textPrimary_),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: tagBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_forward_rounded,
              color: tagColor,
              size: 10.sp,
            ),
          ),
        ),
        Text(
          toCurrency,
          style: AppTextStyles.titleMedium.copyWith(color: tagColor),
        ),
      ],
    );
  }
}

// ── Delete button ──────────────────────────────────────────────────────────

class _DeleteButton extends StatelessWidget {
  final VoidCallback onDelete;
  final dynamic c;

  const _DeleteButton({required this.onDelete, required this.c});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDelete,
      child: Container(
        width: 32.w,
        height: 32.h,
        decoration: BoxDecoration(
          color: c.error_.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          Icons.close_rounded,
          color: c.error_.withValues(alpha: 0.7),
          size: 16.sp,
        ),
      ),
    );
  }
}