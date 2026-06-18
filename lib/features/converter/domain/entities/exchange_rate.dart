import 'package:equatable/equatable.dart';

class ExchangeRate extends Equatable {
  final String baseCurrency;
  final Map<String, double> rates;
  final DateTime date;

  const ExchangeRate({
    required this.baseCurrency,
    required this.rates,
    required this.date,
  });

  @override
  List<Object?> get props => [baseCurrency, rates, date];
}
