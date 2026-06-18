import 'package:dartz/dartz.dart';
import 'package:efg_converter/core/network/failures.dart';
import 'package:efg_converter/features/converter/domain/entities/exchange_rate.dart';
import 'package:efg_converter/features/converter/domain/repositories/converter_repository.dart';

class GetExchangeRatesUseCase {
  final ConverterRepository repository;
  GetExchangeRatesUseCase(this.repository);

  Future<Either<Failure, ExchangeRate>> call({
    required String baseCurrency,
    String? targetCurrency,
  }) {
    return repository.getExchangeRates(
      baseCurrency: baseCurrency,
      targetCurrency: targetCurrency,
    );
  }
}
