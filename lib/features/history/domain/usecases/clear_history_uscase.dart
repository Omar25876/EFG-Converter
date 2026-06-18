import 'package:dartz/dartz.dart';
import 'package:efg_converter/core/network/failures.dart';
import 'package:efg_converter/features/history/domain/repositories/history_repository.dart';

class ClearHistoryUseCase {
  final HistoryRepository repository;
  ClearHistoryUseCase(this.repository);
  Future<Either<Failure, void>> call() => repository.clearHistory();
}