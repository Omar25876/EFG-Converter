import 'package:dartz/dartz.dart';
import 'package:efg_converter/core/network/failures.dart';
import 'package:efg_converter/features/converter/domain/repositories/converter_repository.dart';

class GetCurrenciesUseCase {
  final ConverterRepository repository;
  GetCurrenciesUseCase(this.repository);

  Future<Either<Failure, Map<String, String>>> call() {
    return repository.getCurrencies();
  }
}
