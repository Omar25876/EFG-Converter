import 'package:dartz/dartz.dart';
import 'package:efg_converter/core/network/failures.dart';
import 'package:efg_converter/features/history/domain/entities/conversion_history.dart';
import 'package:efg_converter/features/history/domain/repositories/history_repository.dart';

class GetHistoryUseCase {
  final HistoryRepository repository;
  GetHistoryUseCase(this.repository);
  Future<Either<Failure, List<ConversionHistory>>> call() => repository.getHistory();
}





