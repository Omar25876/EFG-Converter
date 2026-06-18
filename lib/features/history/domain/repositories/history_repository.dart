import 'package:dartz/dartz.dart';
import 'package:efg_converter/core/network/failures.dart';
import 'package:efg_converter/features/history/domain/entities/conversion_history.dart';

abstract class HistoryRepository {
  Future<Either<Failure, List<ConversionHistory>>> getHistory();
  Future<Either<Failure, void>> saveConversion(ConversionHistory conversion);
  Future<Either<Failure, void>> deleteConversion(String id);
  Future<Either<Failure, void>> clearHistory();
}
