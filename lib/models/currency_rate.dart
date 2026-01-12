class CurrencyRate {
  final String id;
  final String currencyCode;
  final String currencyNameAr;
  final String currencyNameEn;
  final double buyRate;
  final double sellRate;
  final double? change;
  final double? changePercent;
  final String? flag;

  CurrencyRate({
    required this.id,
    required this.currencyCode,
    required this.currencyNameAr,
    required this.currencyNameEn,
    required this.buyRate,
    required this.sellRate,
    this.change,
    this.changePercent,
    this.flag,
  });

  factory CurrencyRate.fromJson(Map<String, dynamic> json) {
    return CurrencyRate(
      id: json['id'] as String,
      currencyCode: json['currencyCode'] as String,
      currencyNameAr: json['currencyNameAr'] as String,
      currencyNameEn: json['currencyNameEn'] as String,
      buyRate: (json['buyRate'] as num).toDouble(),
      sellRate: (json['sellRate'] as num).toDouble(),
      change: json['change'] != null ? (json['change'] as num).toDouble() : null,
      changePercent: json['changePercent'] != null ? (json['changePercent'] as num).toDouble() : null,
      flag: json['flag'] as String?,
    );
  }

  String get flagEmoji {
    switch (currencyCode) {
      case 'USD': return '🇺🇸';
      case 'EUR': return '🇪🇺';
      case 'TRY': return '🇹🇷';
      case 'SAR': return '🇸🇦';
      case 'AED': return '🇦🇪';
      case 'EGP': return '🇪🇬';
      case 'JOD': return '🇯🇴';
      case 'KWD': return '🇰🇼';
      case 'GBP': return '🇬🇧';
      case 'QAR': return '🇶🇦';
      default: return '💱';
    }
  }
}

class ExchangeRatesResponse {
  final List<CurrencyRate> rates;
  final String lastUpdated;
  final String source;

  ExchangeRatesResponse({
    required this.rates,
    required this.lastUpdated,
    required this.source,
  });

  factory ExchangeRatesResponse.fromJson(Map<String, dynamic> json) {
    return ExchangeRatesResponse(
      rates: (json['rates'] as List)
          .map((e) => CurrencyRate.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastUpdated: json['lastUpdated'] as String,
      source: json['source'] as String,
    );
  }
}
