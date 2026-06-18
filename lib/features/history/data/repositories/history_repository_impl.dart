import 'package:dartz/dartz.dart';
import 'package:efg_converter/core/network/failures.dart';
import 'package:efg_converter/features/history/data/datasource/history_local_datasource.dart';
import '../../domain/entities/conversion_history.dart';
import '../../domain/repositories/history_repository.dart';
import '../models/conversion_history_model.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryLocalDataSource localDataSource;
  HistoryRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<ConversionHistory>>> getHistory() async {
    try {
      final result = await localDataSource.getHistory();
      return Right(result);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveConversion(ConversionHistory conversion) async {
    try {
      final model = ConversionHistoryModel.fromEntity(conversion);
      await localDataSource.saveConversion(model);
      return const Right(null);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteConversion(String id) async {
    try {
      await localDataSource.deleteConversion(id);
      return const Right(null);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearHistory() async {
    try {
      await localDataSource.clearHistory();
      return const Right(null);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }
}
