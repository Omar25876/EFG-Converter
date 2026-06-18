import '../../domain/entities/conversion_history.dart';

class ConversionHistoryModel extends ConversionHistory {
  const ConversionHistoryModel({
    required super.id,
    required super.amount,
    required super.fromCurrency,
    required super.toCurrency,
    required super.result,
    required super.rate,
    required super.convertedAt,
  });

  factory ConversionHistoryModel.fromJson(Map<String, dynamic> json) {
    return ConversionHistoryModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      fromCurrency: json['fromCurrency'] as String,
      toCurrency: json['toCurrency'] as String,
      result: (json['result'] as num).toDouble(),
      rate: (json['rate'] as num).toDouble(),
      convertedAt: DateTime.parse(json['convertedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'fromCurrency': fromCurrency,
        'toCurrency': toCurrency,
        'result': result,
        'rate': rate,
        'convertedAt': convertedAt.toIso8601String(),
      };

  factory ConversionHistoryModel.fromEntity(ConversionHistory entity) {
    return ConversionHistoryModel(
      id: entity.id,
      amount: entity.amount,
      fromCurrency: entity.fromCurrency,
      toCurrency: entity.toCurrency,
      result: entity.result,
      rate: entity.rate,
      convertedAt: entity.convertedAt,
    );
  }
}
