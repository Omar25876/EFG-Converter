import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

class HiveStorage {
  static const String _boxName = 'currency_converter_box';
  late Box _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  Future<void> write(String key, dynamic value) async {
    await _box.put(key, value);
  }

  dynamic read(String key) {
    return _box.get(key);
  }

  Future<void> delete(String key) async {
    await _box.delete(key);
  }

  Future<void> clear() async {
    await _box.clear();
  }

  // Helpers for JSON lists
  Future<void> writeJsonList(String key, List<Map<String, dynamic>> list) async {
    final encoded = jsonEncode(list);
    await write(key, encoded);
  }

  List<Map<String, dynamic>> readJsonList(String key) {
    final raw = read(key);
    if (raw == null) return [];
    try {
      final decoded = jsonDecode(raw as String) as List;
      return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> writeJsonMap(String key, Map<String, dynamic> map) async {
    final encoded = jsonEncode(map);
    await write(key, encoded);
  }

  Map<String, dynamic>? readJsonMap(String key) {
    final raw = read(key);
    if (raw == null) return null;
    try {
      return Map<String, dynamic>.from(jsonDecode(raw as String) as Map);
    } catch (_) {
      return null;
    }
  }
}