import 'package:dartz/dartz.dart';
import 'package:efg_converter/core/network/failures.dart';
import 'package:efg_converter/features/history/domain/entities/conversion_history.dart';
import 'package:efg_converter/features/history/domain/repositories/history_repository.dart';

class SaveConversionUseCase {
  final HistoryRepository repository;
  SaveConversionUseCase(this.repository);
  Future<Either<Failure, void>> call(ConversionHistory conversion) =>
      repository.saveConversion(conversion);
}
