import 'package:equatable/equatable.dart';

class ConversionHistory extends Equatable {
  final String id;
  final double amount;
  final String fromCurrency;
  final String toCurrency;
  final double result;
  final double rate;
  final DateTime convertedAt;

  const ConversionHistory({
    required this.id,
    required this.amount,
    required this.fromCurrency,
    required this.toCurrency,
    required this.result,
    required this.rate,
    required this.convertedAt,
  });

  @override
  List<Object?> get props => [id, amount, fromCurrency, toCurrency, result, rate, convertedAt];
}
