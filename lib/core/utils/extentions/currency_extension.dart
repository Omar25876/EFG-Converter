
/// Extension on [String] for currency-related display helpers.
extension CurrencyExtension on String {
  /// Returns the flag emoji for a currency code (based on its country ISO).
  /// Falls back to a generic 💱 emoji for unknown currencies.
  String get currencyFlag {
    const Map<String, String> flags = {
      'USD': '🇺🇸',
      'EUR': '🇪🇺',
      'GBP': '🇬🇧',
      'JPY': '🇯🇵',
      'AED': '🇦🇪',
      'SAR': '🇸🇦',
      'EGP': '🇪🇬',
      'CHF': '🇨🇭',
      'CAD': '🇨🇦',
      'AUD': '🇦🇺',
      'CNY': '🇨🇳',
      'INR': '🇮🇳',
      'TRY': '🇹🇷',
      'KWD': '🇰🇼',
      'QAR': '🇶🇦',
      'BHD': '🇧🇭',
      'JOD': '🇯🇴',
      'MYR': '🇲🇾',
      'SEK': '🇸🇪',
      'NOK': '🇳🇴',
      'DKK': '🇩🇰',
      'SGD': '🇸🇬',
      'HKD': '🇭🇰',
      'MXN': '🇲🇽',
      'BRL': '🇧🇷',
      'ZAR': '🇿🇦',
      'RUB': '🇷🇺',
      'PLN': '🇵🇱',
      'THB': '🇹🇭',
      'IDR': '🇮🇩',
      'NZD': '🇳🇿',
      'PKR': '🇵🇰',
      'IQD': '🇮🇶',
      'MAD': '🇲🇦',
      'TND': '🇹🇳',
      'LYD': '🇱🇾',
      'DZD': '🇩🇿',
      'OMR': '🇴🇲',
      'YER': '🇾🇪',
      'LBP': '🇱🇧',
      'SYP': '🇸🇾',
    };
    return flags[toUpperCase()] ?? '💱';
  }

  /// Returns a short display label: flag + code.
  /// Example: "🇺🇸 USD"
  String get currencyLabel => '$currencyFlag $this';

  /// Returns just the first 2 letters uppercased, used for avatar fallback.
  String get currencyInitials =>
      length >= 2 ? substring(0, 2).toUpperCase() : toUpperCase();
}

/// Standalone number formatting helpers (always English locale).
class CurrencyFormatter {
  CurrencyFormatter._();

  /// Formats a number with up to 4 decimal places, English locale.
  /// e.g. 1234567.8 → "1,234,567.8"
  static final NumberFormat amount = NumberFormat('#,##0.####', 'en_US');

  /// Formats a rate with up to 6 decimal places, English locale.
  /// e.g. 0.000312 → "0.000312"
  static final NumberFormat rate = NumberFormat('#,##0.######', 'en_US');

  /// Formats a large number with 2 fixed decimal places, English locale.
  /// e.g. 1234.5 → "1,234.50"
  static final NumberFormat fixed2 = NumberFormat('#,##0.00', 'en_US');

  /// Formats [value] as an amount string (English locale, up to 4 decimals).
  static String formatAmount(double value) => amount.format(value);

  /// Formats [value] as a rate string (English locale, up to 6 decimals).
  static String formatRate(double value) => rate.format(value);

  /// Formats [value] with exactly 2 decimal places (English locale).
  static String formatFixed(double value) => fixed2.format(value);
}