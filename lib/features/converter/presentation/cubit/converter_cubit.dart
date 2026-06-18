import 'package:efg_converter/core/network/network_info.dart';
import 'package:efg_converter/features/converter/domain/usecases/get_currencies_usecase.dart';
import 'package:efg_converter/features/converter/domain/usecases/get_exchange_rates_usecase.dart';
import 'package:efg_converter/features/history/domain/entities/conversion_history.dart';
import 'package:efg_converter/features/history/domain/usecases/save_conversion_usecase.dart';
import 'package:efg_converter/features/history/presentation/cubit/history_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'converter_state.dart';

class ConverterCubit extends Cubit<ConverterState> {
  final GetExchangeRatesUseCase getExchangeRates;
  final GetCurrenciesUseCase getCurrencies;
  final SaveConversionUseCase saveConversion;
  final NetworkInfo networkInfo;
  final HistoryCubit historyCubit;

  static const _uuid = Uuid();

  ConverterCubit({
    required this.getExchangeRates,
    required this.getCurrencies,
    required this.saveConversion,
    required this.networkInfo,
    required this.historyCubit,
  }) : super(ConverterInitial());

  Future<void> loadCurrencies() async {
    emit(CurrenciesLoading());
    final result = await getCurrencies();
    result.fold(
          (failure) => emit(ConverterError(message: failure.message)),
          (currencies) {
        final from = currencies.containsKey('USD') ? 'USD' : currencies.keys.first;
        final to = currencies.containsKey('EUR') ? 'EUR' : currencies.keys.elementAt(1);
        emit(CurrenciesLoaded(currencies: currencies, selectedFrom: from, selectedTo: to));
        getExchangeRates(baseCurrency: from, targetCurrency: to);
      },
    );
  }

  Future<void> convert({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  }) async {
    final currentCurrencies = _currentCurrencies;
    emit(ConversionLoading(
      currencies: currentCurrencies,
      selectedFrom: fromCurrency,
      selectedTo: toCurrency,
    ));

    final isOnline = await networkInfo.isConnected;

    final result = await getExchangeRates(
      baseCurrency: fromCurrency,
      targetCurrency: toCurrency,
    );

    result.fold(
          (failure) => emit(ConverterError(
          message: failure.message, currencies: currentCurrencies)),
          (rates) async {
            final rate = fromCurrency == toCurrency
                ? 1.0
                : (rates.rates[toCurrency] ?? 0.0);
        final converted = amount * rate;

        await saveConversion(ConversionHistory(
          id: _uuid.v4(),
          amount: amount,
          fromCurrency: fromCurrency,
          toCurrency: toCurrency,
          result: converted,
          rate: rate,
          convertedAt: DateTime.now(),
        ));

        historyCubit.loadHistory();

        emit(ConversionSuccess(
          currencies: currentCurrencies,
          amount: amount,
          fromCurrency: fromCurrency,
          toCurrency: toCurrency,
          result: converted,
          rate: rate,
          isOffline: !isOnline,
        ));
      },
    );
  }
  void swapCurrencies({
    required String fromCurrency,
    required String toCurrency,
  }) {
    final currencies = _currentCurrencies;
    if (currencies.isEmpty) return;
    emit(CurrenciesLoaded(
      currencies: currencies,
      selectedFrom: toCurrency,
      selectedTo: fromCurrency,
    ));
  }

  Map<String, String> get _currentCurrencies {
    final s = state;
    if (s is CurrenciesLoaded) return s.currencies;
    if (s is ConversionSuccess) return s.currencies;
    if (s is ConversionLoading) return s.currencies;
    if (s is ConverterError && s.currencies != null) return s.currencies!;
    return {};
  }
}