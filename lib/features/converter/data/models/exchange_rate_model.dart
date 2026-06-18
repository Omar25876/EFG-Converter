import '../../domain/entities/exchange_rate.dart';

class ExchangeRateModel extends ExchangeRate {
  const ExchangeRateModel({
    required super.baseCurrency,
    required super.rates,
    required super.date,
  });

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) {
    final rawRates = json['rates'] as Map<String, dynamic>? ?? {};
    final rates = rawRates.map(
      (key, value) => MapEntry(key, (value as num).toDouble()),
    );
    return ExchangeRateModel(
      baseCurrency: json['base'] as String,
      rates: rates,
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'base': baseCurrency,
        'rates': rates,
        'date': date.toIso8601String(),
      };
}
