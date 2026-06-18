import 'package:dio/dio.dart';
import 'package:efg_converter/core/network/api_exceptions.dart';
import 'package:efg_converter/core/network/dio_client.dart';
import 'package:efg_converter/core/utils/constants.dart';
import '../models/exchange_rate_model.dart';

abstract class ConverterRemoteDataSource {
  Future<ExchangeRateModel> getExchangeRates({required String baseCurrency});
  Future<Map<String, String>> getCurrencies();
}

class ConverterRemoteDataSourceImpl implements ConverterRemoteDataSource {
  final DioClient dio;
  ConverterRemoteDataSourceImpl(this.dio);

  @override
  Future<ExchangeRateModel> getExchangeRates({
    required String baseCurrency,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.latest,
        queryParams: {'from': baseCurrency}, // no 'to' -> full table
      );

      if (response.statusCode == 200) {
        return ExchangeRateModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw const ServerException();
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const NetworkException();
      }
      throw const ServerException();
    }
  }

  @override
  Future<Map<String, String>> getCurrencies() async {
    try {
      final response = await dio.get(ApiConstants.currencies);
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return data.map((k, v) => MapEntry(k, v.toString()));
      }
      throw const ServerException();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw const NetworkException();
      }
      throw const ServerException();
    }
  }
}