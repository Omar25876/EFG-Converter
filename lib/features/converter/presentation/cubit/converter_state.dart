part of 'converter_cubit.dart';

abstract class ConverterState extends Equatable {
  const ConverterState();

  @override
  List<Object?> get props => [];
}

class ConverterInitial extends ConverterState {}

class CurrenciesLoading extends ConverterState {}

class CurrenciesLoaded extends ConverterState {
  final Map<String, String> currencies;
  final String selectedFrom;
  final String selectedTo;

  const CurrenciesLoaded({
    required this.currencies,
    required this.selectedFrom,
    required this.selectedTo,
  });

  @override
  List<Object?> get props => [currencies, selectedFrom, selectedTo];
}

class ConversionLoading extends ConverterState {
  final Map<String, String> currencies;
  final String selectedFrom;
  final String selectedTo;

  const ConversionLoading({
    required this.currencies,
    required this.selectedFrom,
    required this.selectedTo,
  });

  @override
  List<Object?> get props => [currencies, selectedFrom, selectedTo];
}

class ConversionSuccess extends ConverterState {
  final Map<String, String> currencies;
  final double amount;
  final String fromCurrency;
  final String toCurrency;
  final double result;
  final double rate;
  final bool isOffline;

  const ConversionSuccess({
    required this.currencies,
    required this.amount,
    required this.fromCurrency,
    required this.toCurrency,
    required this.result,
    required this.rate,
    this.isOffline = false,
  });

  @override
  List<Object?> get props =>
      [currencies, amount, fromCurrency, toCurrency, result, rate, isOffline];
}

class ConverterError extends ConverterState {
  final String message;
  final Map<String, String>? currencies;

  const ConverterError({required this.message, this.currencies});

  @override
  List<Object?> get props => [message, currencies];
}