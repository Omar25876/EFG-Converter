import 'package:dartz/dartz.dart';
import 'package:efg_converter/core/network/failures.dart';
import 'package:efg_converter/features/history/domain/repositories/history_repository.dart';

class DeleteConversionUseCase {
  final HistoryRepository repository;
  DeleteConversionUseCase(this.repository);
  Future<Either<Failure, void>> call(String id) => repository.deleteConversion(id);
}