class Temperatures {
  final Time time;
  final String disclaimer;
  final String chartName;
  final Bpi bpi;

  Temperatures({
    required this.time,
    required this.disclaimer,
    required this.chartName,
    required this.bpi,
  });

  factory Temperatures.fromJson(Map<String, dynamic> json) {
    return Temperatures(
      time: Time.fromJson(json['time']),
      disclaimer: json['disclaimer'],
      chartName: json['chartName'],
      bpi: Bpi.fromJson(json['bpi']),
    );
  }
}

class Bpi {
  final Eur usd;
  final Eur gbp;
  final Eur eur;

  Bpi({
    required this.usd,
    required this.gbp,
    required this.eur,
  });
  List<Eur> get currencies => [usd, gbp, eur];
  factory Bpi.fromJson(Map<String, dynamic> json) {
    return Bpi(
      usd: Eur.fromJson(json['USD']),
      gbp: Eur.fromJson(json['GBP']),
      eur: Eur.fromJson(json['EUR']),
    );
  }
}

class Eur {
  final String code;
  final String symbol;
  final String rate;
  final String description;
  final double rateFloat;

  Eur({
    required this.code,
    required this.symbol,
    required this.rate,
    required this.description,
    required this.rateFloat,
  });

  factory Eur.fromJson(Map<String, dynamic> json) {
    return Eur(
      code: json['code'],
      symbol: json['symbol'],
      rate: json['rate'],
      description: json['description'],
      rateFloat: json['rate_float'],
    );
  }
}

class Time {
  final String updated;
  final DateTime updatedIso;
  final String updateduk;

  Time({
    required this.updated,
    required this.updatedIso,
    required this.updateduk,
  });

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      updated: json['updated'],
      updatedIso: DateTime.parse(json['updatedISO']),
      updateduk: json['updateduk'],
    );
  }
}