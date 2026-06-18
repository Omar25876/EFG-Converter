import 'package:easy_localization/easy_localization.dart';
import 'package:efg_converter/core/styles/app_colors.dart';
import 'package:efg_converter/core/styles/app_text_styles.dart';
import 'package:efg_converter/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui'as ui;
class AmountCard extends StatelessWidget {
  const AmountCard({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

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
            color: accent.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.toll_rounded, color: accent, size: 16.sp),
              ),
              SizedBox(width: 10.w),
              Text(
                tr('amount'),
                style: AppTextStyles.labelSmall
                    .copyWith(color: c.textSecondary_),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          TextFormField(
            controller: controller,
            keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            textDirection: ui.TextDirection.ltr,
            style: AppTextStyles.displayMedium.copyWith(
              fontSize: 36.sp,
              color: c.textPrimary_,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              hintText: '0.00',
              hintStyle: AppTextStyles.displayMedium.copyWith(
                fontSize: 36.sp,
                color: c.textHint_,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
              contentPadding: EdgeInsets.zero,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return tr('amount_required');
              }
              final n = double.tryParse(value);
              if (n == null) return tr('amount_invalid');
              if (n <= 0) return tr('amount_positive');
              return null;
            },
          ),
          // Subtle bottom accent line
          Container(
            height: 2.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accent.withValues(alpha: 0.6),
                  accent.withValues(alpha: 0.0),
                ],
              ),
              borderRadius: BorderRadius.circular(1.r),
            ),
          ),
        ],
      ),
    );
  }
}