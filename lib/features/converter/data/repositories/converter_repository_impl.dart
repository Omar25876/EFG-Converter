import 'package:dartz/dartz.dart';
import 'package:efg_converter/core/network/api_exceptions.dart';
import 'package:efg_converter/core/network/failures.dart';
import 'package:efg_converter/core/network/network_info.dart';
import 'package:efg_converter/features/converter/data/datasource/converter_local_datasource.dart';
import 'package:efg_converter/features/converter/data/datasource/converter_remote_datasource.dart';
import 'package:efg_converter/features/converter/data/models/exchange_rate_model.dart';
import 'package:efg_converter/features/converter/domain/entities/exchange_rate.dart';
import 'package:efg_converter/features/converter/domain/repositories/converter_repository.dart';

class ConverterRepositoryImpl implements ConverterRepository {
  final ConverterRemoteDataSource remoteDataSource;
  final ConverterLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ConverterRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ExchangeRate>> getExchangeRates({
    required String baseCurrency,
    String? targetCurrency, // kept for interface compatibility, unused for the API call
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getExchangeRates(baseCurrency: baseCurrency);
        await localDataSource.cacheExchangeRates(result);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      try {
        final cached = await localDataSource.getCachedExchangeRates();
        return Right(_crossRate(cached, baseCurrency));
      } on CacheException {
        return const Left(CacheFailure('No cached exchange rates available offline'));
      }
    }
  }

  /// Rebuilds a full rates table relative to [from] using whatever full
  /// snapshot is cached, regardless of which base it was anchored on.
  ExchangeRateModel _crossRate(ExchangeRateModel cached, String from) {
    if (cached.baseCurrency == from) return cached;

    double rateOf(String code) =>
        code == cached.baseCurrency ? 1.0 : (cached.rates[code] ?? 0.0);

    final fromRate = rateOf(from);
    if (fromRate == 0) {
      throw const CacheException('Currency not available in cached data');
    }

    final newRates = <String, double>{
      cached.baseCurrency: 1 / fromRate,
      ...Map.fromEntries(
        cached.rates.entries.map((e) => MapEntry(e.key, e.value / fromRate)),
      ),
    };
    newRates.remove(from);

    return ExchangeRateModel(
      baseCurrency: from,
      rates: newRates,
      date: cached.date,
    );
  }

  @override
  Future<Either<Failure, Map<String, String>>> getCurrencies() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getCurrencies();
        await localDataSource.cacheCurrencies(result);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException {
        return _fallbackCurrencies();
      }
    } else {
      return _fallbackCurrencies();
    }
  }

  Either<Failure, Map<String, String>> _fallbackCurrencies() {
    final cached = localDataSource.getCachedCurrencies();
    if (cached != null) return Right(cached);
    return const Left(NetworkFailure('No internet connection and no cached currencies available'));
  }
}