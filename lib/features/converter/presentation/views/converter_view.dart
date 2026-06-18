import 'package:easy_localization/easy_localization.dart';
import 'package:efg_converter/core/components/shared_widgets.dart';
import 'package:efg_converter/core/di/service_locator.dart';
import 'package:efg_converter/core/styles/app_colors.dart';
import 'package:efg_converter/features/converter/presentation/cubit/converter_cubit.dart';
import 'package:efg_converter/features/converter/presentation/widgets/amount_card.dart';
import 'package:efg_converter/features/converter/presentation/widgets/converter_app_bar.dart';
import 'package:efg_converter/features/converter/presentation/widgets/exchange_panel.dart';
import 'package:efg_converter/features/converter/presentation/widgets/result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ConverterView extends StatefulWidget {
  const ConverterView({super.key});

  @override
  State<ConverterView> createState() => _ConverterViewState();
}

class _ConverterViewState extends State<ConverterView>
    with SingleTickerProviderStateMixin {
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late ConverterCubit _cubit;
  late AnimationController _swapAnimController;

  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';

  @override
  void initState() {
    super.initState();
    _cubit = sl<ConverterCubit>()..loadCurrencies();
    _swapAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _cubit.close();
    _swapAnimController.dispose();
    super.dispose();
  }

  void _doSwap() {
    _swapAnimController.forward(from: 0);
    _cubit.swapCurrencies(
      fromCurrency: _fromCurrency,
      toCurrency: _toCurrency,
    );
    setState(() {
      final tmp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<ConverterCubit, ConverterState>(
        listener: (context, state) {
          if (state is CurrenciesLoaded) {
            _fromCurrency = state.selectedFrom;
            _toCurrency = state.selectedTo;
          }
          if (state is ConversionSuccess) {
            _fromCurrency = state.fromCurrency;
            _toCurrency = state.toCurrency;
          }
          if (state is ConversionLoading) {
            _fromCurrency = state.selectedFrom;
            _toCurrency = state.selectedTo;
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: c.scaffold,
            body: CustomScrollView(
              slivers: [
                const ConverterAppBar(),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      if (state is ConversionSuccess && state.isOffline)
                        OfflineBanner(message: tr('offline_banner')),
                      _buildBody(context, state),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ConverterState state) {
    if (state is CurrenciesLoading) {
      return SizedBox(
        height: 400.h,
        child: LoadingWidget(message: tr('loading')),
      );
    }

    if (state is ConverterError && state.currencies == null) {
      return SizedBox(
        height: 400.h,
        child: ErrorStateWidget(
          message: state.message,
          onRetry: () => _cubit.loadCurrencies(),
        ),
      );
    }

    final currencies = _getCurrencies(state);
    final isLoading = state is ConversionLoading;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            ExchangePanel(
              fromCurrency: _fromCurrency,
              toCurrency: _toCurrency,
              currencies: currencies,
              swapAnimController: _swapAnimController,
              onFromChanged: (v) =>
                  setState(() => _fromCurrency = v ?? _fromCurrency),
              onToChanged: (v) =>
                  setState(() => _toCurrency = v ?? _toCurrency),
              onSwap: _doSwap,
            ),
            SizedBox(height: 20.h),
            AmountCard(controller: _amountController),
            SizedBox(height: 20.h),
            AppButton(
              label: tr('convert'),
              isLoading: isLoading,
              icon: Icons.currency_exchange_rounded,
              onPressed: isLoading || currencies.isEmpty
                  ? null
                  : () {
                if (_formKey.currentState!.validate()) {
                  FocusScope.of(context).unfocus();
                  _cubit.convert(
                    amount: double.parse(_amountController.text),
                    fromCurrency: _fromCurrency,
                    toCurrency: _toCurrency,
                  );
                }
              },
            ),
            SizedBox(height: 28.h),
            if (state is ConversionSuccess) ResultCard(state: state),
            SizedBox(height: 85.h),
          ],
        ),
      ),
    );
  }

  Map<String, String> _getCurrencies(ConverterState state) {
    if (state is CurrenciesLoaded) return state.currencies;
    if (state is ConversionSuccess) return state.currencies;
    if (state is ConversionLoading) return state.currencies;
    if (state is ConverterError && state.currencies != null) {
      return state.currencies!;
    }
    return {};
  }
}