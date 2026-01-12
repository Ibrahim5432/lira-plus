class GoldRate {
  final String id;
  final int karat;
  final String karatAr;
  final double pricePerGram;
  final double? change;
  final double? changePercent;

  GoldRate({
    required this.id,
    required this.karat,
    required this.karatAr,
    required this.pricePerGram,
    this.change,
    this.changePercent,
  });

  factory GoldRate.fromJson(Map<String, dynamic> json) {
    return GoldRate(
      id: json['id'] as String,
      karat: json['karat'] as int,
      karatAr: json['karatAr'] as String,
      pricePerGram: (json['pricePerGram'] as num).toDouble(),
      change: json['change'] != null ? (json['change'] as num).toDouble() : null,
      changePercent: json['changePercent'] != null ? (json['changePercent'] as num).toDouble() : null,
    );
  }
}

class GoldRatesResponse {
  final List<GoldRate> rates;
  final String lastUpdated;
  final String source;

  GoldRatesResponse({
    required this.rates,
    required this.lastUpdated,
    required this.source,
  });

  factory GoldRatesResponse.fromJson(Map<String, dynamic> json) {
    return GoldRatesResponse(
      rates: (json['rates'] as List)
          .map((e) => GoldRate.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastUpdated: json['lastUpdated'] as String,
      source: json['source'] as String,
    );
  }
}
