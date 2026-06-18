
import 'package:efg_converter/core/storage/hive_storage.dart';
import 'package:efg_converter/core/utils/constants.dart';
import 'package:efg_converter/features/history/data/models/conversion_history_model.dart';

abstract class HistoryLocalDataSource {
  Future<List<ConversionHistoryModel>> getHistory();
  Future<void> saveConversion(ConversionHistoryModel conversion);
  Future<void> deleteConversion(String id);
  Future<void> clearHistory();
}

class HistoryLocalDataSourceImpl implements HistoryLocalDataSource {
  final HiveStorage storage;
  HistoryLocalDataSourceImpl(this.storage);

  @override
  Future<List<ConversionHistoryModel>> getHistory() async {
    final list = storage.readJsonList(StorageKeys.conversionHistory);
    return list.map((e) => ConversionHistoryModel.fromJson(e)).toList();
  }

  @override
  Future<void> saveConversion(ConversionHistoryModel conversion) async {
    final list = storage.readJsonList(StorageKeys.conversionHistory);
    list.insert(0, conversion.toJson());
    await storage.writeJsonList(StorageKeys.conversionHistory, list);
  }

  @override
  Future<void> deleteConversion(String id) async {
    final list = storage.readJsonList(StorageKeys.conversionHistory);
    list.removeWhere((e) => e['id'] == id);
    await storage.writeJsonList(StorageKeys.conversionHistory, list);
  }

  @override
  Future<void> clearHistory() async {
    await storage.writeJsonList(StorageKeys.conversionHistory, []);
  }
}
