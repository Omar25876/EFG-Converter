import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_exceptions.dart';
import 'network_info.dart';

class DioClient {
  late final Dio _dio;
  final NetworkInfo _networkInfo;

  DioClient({
    required NetworkInfo networkInfo,
    required String      baseUrl,
  })  : _networkInfo = networkInfo
  {
    final baseOptions = BaseOptions(
      baseUrl:        baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout:    const Duration(seconds: 30),
      validateStatus: (status) => status != null && status < 600,
    );

    _dio = Dio(baseOptions);

    _dio.interceptors.add(
      InterceptorsWrapper(
        // Log request
        onRequest: (options, handler) {
          _log('➡️ REQUEST', {
            'URL':    options.uri.toString(),
            'METHOD': options.method,
            'BODY':   _fmtBody(options.data),
          });
          handler.next(options);
        },

        // Log response
        onResponse: (response, handler) {
          _log('✅ RESPONSE', {
            'URL':    response.requestOptions.uri.toString(),
            'STATUS': response.statusCode,
            'DATA':   response.data,
          });
          handler.next(response);
        },

        // Log error
        onError: (DioException e, handler) {
          _log('❌ ERROR', {
            'URL':    e.requestOptions.uri.toString(),
            'STATUS': e.response?.statusCode,
            'ERROR':  e.response?.data ?? e.message,
          });
          handler.next(e);
        },
      ),
    );
  }

  //  HTTP Methods

  Future<Response<T>> get<T>(
      String path, {
        Map<String, dynamic>? queryParams,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    await _checkInternet();
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParams,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<Response<T>> post<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParams,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    await _checkInternet();
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParams,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<Response<T>> put<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParams,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    await _checkInternet();
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParams,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<Response<T>> patch<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParams,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    await _checkInternet();
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParams,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<Response<T>> delete<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParams,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    await _checkInternet();
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParams,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  // ══════════════════════════════════════════════════════════════
  //  Reusable response parser
  // ══════════════════════════════════════════════════════════════

  /// Parses any endpoint that returns
  /// `{ success, enMessage, arMessage, data }`.
  /// Pass [fromJson] to deserialize `data` into your model.
  static T parseResponse<T>(
      Response response,
      T Function(dynamic json) fromJson,
      ) {
    final body = response.data;
    if (body is! Map<String, dynamic>) {
      throw const BadRequestException('Unexpected response format');
    }
    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw BadRequestException(
        body['enMessage'] as String? ?? 'Request failed',
      );
    }
    return fromJson(body['data']);
  }

  // ── Helpers ───────────────────────────────────────────────────
  Future<void> _checkInternet() async {
    if (!await _networkInfo.isConnected) throw const NoInternetException();
  }

  ApiException _mapError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutExceptionApi();

      case DioExceptionType.connectionError:
        return BadRequestException(
          'Connection failed — ${e.message ?? "Cannot reach server"}',
        );

      case DioExceptionType.badResponse:
        final status = e.response?.statusCode ?? 0;
        final msg    = _extractMsg(e.response?.data);
        if (status == 401) return const UnauthorizedException();
        if (status >= 500) return const ServerException();
        return BadRequestException(msg ?? 'Request failed');

      case DioExceptionType.cancel:
        return const BadRequestException('Request cancelled');

      default:
        return BadRequestException(e.message ?? 'Unknown error');
    }
  }

  String? _extractMsg(dynamic data) {
    if (data == null)        return null;
    if (data is String)      return data;
    if (data is Map) {
      return (data['enMessage'] ?? data['message'] ?? data['error'])
          ?.toString();
    }
    return data.toString();
  }

  dynamic _fmtBody(dynamic data) {
    if (data is FormData) {
      return {
        'fields': data.fields.map((e) => '${e.key}: ${e.value}').toList(),
        'files':  data.files.map((e) => '${e.key}: ${e.value.filename}').toList(),
      };
    }
    return data;
  }

  void _log(String title, Map<String, dynamic> data) {
    if (!kDebugMode) return;
    debugPrint('━━━━━━ $title ━━━━━━');
    try {
      debugPrint(const JsonEncoder.withIndent('  ').convert(data));
    } catch (_) {
      debugPrint(data.toString());
    }
  }
}