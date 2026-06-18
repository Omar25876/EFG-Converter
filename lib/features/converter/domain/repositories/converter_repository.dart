import 'package:dartz/dartz.dart';
import 'package:efg_converter/core/network/failures.dart';
import 'package:efg_converter/features/converter/domain/entities/exchange_rate.dart';

abstract class ConverterRepository {
  Future<Either<Failure, ExchangeRate>> getExchangeRates({
    required String baseCurrency,
    String? targetCurrency,
  });

  Future<Either<Failure, Map<String, String>>> getCurrencies();
}
