import 'package:easy_localization/easy_localization.dart';
import 'package:efg_converter/core/styles/app_colors.dart';
import 'package:efg_converter/core/styles/app_text_styles.dart';
import 'package:efg_converter/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'currency_picker_sheet.dart';

class ExchangePanel extends StatelessWidget {
  const ExchangePanel({
    super.key,
    required this.fromCurrency,
    required this.toCurrency,
    required this.currencies,
    required this.swapAnimController,
    required this.onFromChanged,
    required this.onToChanged,
    required this.onSwap,
  });

  final String fromCurrency;
  final String toCurrency;
  final Map<String, String> currencies;
  final AnimationController swapAnimController;
  final ValueChanged<String?> onFromChanged;
  final ValueChanged<String?> onToChanged;
  final VoidCallback onSwap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: c.border_, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          CurrencyRow(
            label: tr('from_currency'),
            value: fromCurrency,
            currencies: currencies,
            isFrom: true,
            onChanged: onFromChanged,
          ),
          SwapDivider(
            animController: swapAnimController,
            onSwap: onSwap,
          ),
          CurrencyRow(
            label: tr('to_currency'),
            value: toCurrency,
            currencies: currencies,
            isFrom: false,
            onChanged: onToChanged,
          ),
        ],
      ),
    );
  }
}

// ── Currency Row ─────────────────────────────────────────────────────────────

class CurrencyRow extends StatelessWidget {
  const CurrencyRow({
    super.key,
    required this.label,
    required this.value,
    required this.currencies,
    required this.isFrom,
    required this.onChanged,
  });

  final String label;
  final String value;
  final Map<String, String> currencies;
  final bool isFrom;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tagColor = isFrom ? primary : accent;
    final tagBg = isFrom
        ? primary.withValues(alpha: 0.12)
        : accent.withValues(alpha: 0.12);

    return InkWell(
      onTap: () => CurrencyPickerSheet.show(
        context: context,
        currencies: currencies,
        current: value,
        onChanged: onChanged,
      ),
      borderRadius: BorderRadius.vertical(
        top: isFrom ? Radius.circular(24.r) : Radius.zero,
        bottom: isFrom ? Radius.zero : Radius.circular(24.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        child: Row(
          children: [
            // Direction icon
            Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: tagBg,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Icon(
                  isFrom
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  color: tagColor,
                  size: 18.sp,
                ),
              ),
            ),
            SizedBox(width: 14.w),

            // Label + currency name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style:
                    AppTextStyles.caption.copyWith(color: c.textSecondary_),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    currencies[value] ?? value,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: c.textPrimary_),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Currency code pill
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: tagBg,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: tagColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: tagColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: tagColor,
                    size: 16.sp,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Swap Divider ─────────────────────────────────────────────────────────────

class SwapDivider extends StatelessWidget {
  const SwapDivider({
    super.key,
    required this.animController,
    required this.onSwap,
  });

  final AnimationController animController;
  final VoidCallback onSwap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return SizedBox(
      height: 2,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(height: 0.8, color: c.border_),
          Positioned(
            child: GestureDetector(
              onTap: onSwap,
              child: AnimatedBuilder(
                animation: animController,
                builder: (_, child) => Transform.rotate(
                  angle: animController.value * 3.14159,
                  child: child,
                ),
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    gradient: heroGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primary.withValues(alpha: 0.45),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.swap_vert_rounded,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}