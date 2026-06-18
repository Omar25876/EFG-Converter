class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.frankfurter.app';
  static const String latest = '/latest';
  static const String currencies = '/currencies';

  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}

class StorageKeys {
  StorageKeys._();

  static const String cachedRates = 'cached_rates';
  static const String cachedRatesTimestamp = 'cached_rates_timestamp';
  static const String conversionHistory = 'conversion_history';
  static const String themeMode = 'theme_mode';
  static const String language = 'language';
}