import 'package:efg_converter/core/network/api_exceptions.dart';
import 'package:efg_converter/core/utils/constants.dart';

import '../../../../core/storage/hive_storage.dart';
import '../models/exchange_rate_model.dart';

abstract class ConverterLocalDataSource {
  Future<void> cacheExchangeRates(ExchangeRateModel rates);
  Future<ExchangeRateModel> getCachedExchangeRates();
  Future<void> cacheCurrencies(Map<String, String> currencies);
  Map<String, String>? getCachedCurrencies();
}

class ConverterLocalDataSourceImpl implements ConverterLocalDataSource {
  final HiveStorage storage;
  ConverterLocalDataSourceImpl(this.storage);

  @override
  Future<void> cacheExchangeRates(ExchangeRateModel rates) async {
    await storage.writeJsonMap(StorageKeys.cachedRates, rates.toJson());
    await storage.write(
      StorageKeys.cachedRatesTimestamp,
      DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<ExchangeRateModel> getCachedExchangeRates() async {
    final json = storage.readJsonMap(StorageKeys.cachedRates);
    if (json == null) throw const CacheException('No cached rates found');
    return ExchangeRateModel.fromJson(json);
  }

  @override
  Future<void> cacheCurrencies(Map<String, String> currencies) async {
    await storage.writeJsonMap('currencies_cache', currencies);
  }

  @override
  Map<String, String>? getCachedCurrencies() {
    final json = storage.readJsonMap('currencies_cache');
    if (json == null) return null;
    return json.map((k, v) => MapEntry(k, v.toString()));
  }
}