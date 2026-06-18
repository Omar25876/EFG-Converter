import 'package:easy_localization/easy_localization.dart';
import 'package:efg_converter/core/styles/app_colors.dart';
import 'package:efg_converter/core/styles/app_text_styles.dart';
import 'package:efg_converter/core/styles/colors.dart';
import 'package:efg_converter/core/utils/extentions/currency_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurrencyPickerSheet extends StatefulWidget {
  const CurrencyPickerSheet({
    super.key,
    required this.currencies,
    required this.current,
    required this.onChanged,
  });

  final Map<String, String> currencies;
  final String current;
  final ValueChanged<String?> onChanged;

  static void show({
    required BuildContext context,
    required Map<String, String> currencies,
    required String current,
    required ValueChanged<String?> onChanged,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CurrencyPickerSheet(
        currencies: currencies,
        current: current,
        onChanged: onChanged,
      ),
    );
  }

  @override
  State<CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<CurrencyPickerSheet> {
  late List<MapEntry<String, String>> _filtered;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filtered = widget.currencies.entries.toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      _filtered = widget.currencies.entries
          .where((e) =>
      e.key.toLowerCase().contains(query.toLowerCase()) ||
          e.value.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Container(
      height: 0.75.sh,
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        border: Border.all(color: c.border_.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          // Handle
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: c.border_,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 16.h),

          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                ShaderMask(
                  shaderCallback: (b) => heroGradient.createShader(b),
                  child: Text(
                    tr('select_currency'),
                    style:
                    AppTextStyles.titleLarge.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Search field
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(
              decoration: BoxDecoration(
                color: c.inputBg,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: c.border_),
              ),
              child: TextField(
                controller: _searchController,
                style:
                AppTextStyles.bodyMedium.copyWith(color: c.textPrimary_),
                decoration: InputDecoration(
                  hintText: tr('search_currency'),
                  hintStyle:
                  AppTextStyles.bodyMedium.copyWith(color: c.textHint_),
                  prefixIcon:
                  Icon(Icons.search_rounded, color: c.textSecondary_),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                onChanged: _onSearch,
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // Currency list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: _filtered.length,
              itemBuilder: (_, i) {
                final entry = _filtered[i];
                final isSelected = entry.key == widget.current;

                return InkWell(
                  onTap: () {
                    widget.onChanged(entry.key);
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 6.h),
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12.r),
                      border: isSelected
                          ? Border.all(color: primary.withValues(alpha: 0.3))
                          : null,
                    ),
                    child: Row(
                      children: [
                        // Avatar / initials box
                        Container(
                          width: 42.w,
                          height: 42.h,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? primary.withValues(alpha: 0.15)
                                : c.inputBg,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Center(
                            child: Text(
                              entry.key.currencyInitials,
                              style: AppTextStyles.labelLarge.copyWith(
                                color: isSelected ? primary : c.textSecondary_,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 14.w),

                        // Code + name
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key,
                                style: AppTextStyles.titleMedium.copyWith(
                                  color:
                                  isSelected ? primary : c.textPrimary_,
                                ),
                              ),
                              Text(
                                entry.value,
                                style: AppTextStyles.caption
                                    .copyWith(color: c.textSecondary_),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        if (isSelected)
                          Icon(Icons.check_circle_rounded,
                              color: primary, size: 20.sp),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}