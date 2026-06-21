import 'package:gosheep_mobile/data/models/sheep_breeding.dart';

class RecommendationResult {
  final SheepBreeding selectedSheep;
  final List<RecommendationItem> recommendations;
  final int total;

  const RecommendationResult({
    required this.selectedSheep,
    required this.recommendations,
    required this.total,
  });

  factory RecommendationResult.fromJson(Map<String, dynamic> json) {
    return RecommendationResult(
      selectedSheep: SheepBreeding.fromJson(json['selected_sheep']),
      recommendations: (json['recommendations'] as List)
          .map((e) => RecommendationItem.fromJson(e))
          .toList(),
      total: json['total'] as int,
    );
  }
}

class RecommendationItem {
  final int? recommendationId;
  final RecommendationSheep sheep;
  final double inbreedingCoefficient;
  final double inbreedingPercent;
  final Map<String, double> eweEbv;
  final Map<String, double> ramEbv;
  final Map<String, double> expectedEbvOffspring;
  final RecommendationScore scores;

  const RecommendationItem({
    this.recommendationId,
    required this.sheep,
    required this.inbreedingCoefficient,
    required this.inbreedingPercent,
    required this.eweEbv,
    required this.ramEbv,
    required this.expectedEbvOffspring,
    required this.scores,
  });

  factory RecommendationItem.fromJson(Map<String, dynamic> json) {
    return RecommendationItem(
      recommendationId: json['recommendation_id'] as int?,
      sheep: RecommendationSheep.fromJson(json['sheep']),
      inbreedingCoefficient: (json['inbreeding_coefficient'] as num).toDouble(),
      inbreedingPercent: (json['inbreeding_percent'] as num).toDouble(),
      eweEbv: _parseEbvMap(json['ewe_ebv']),
      ramEbv: _parseEbvMap(json['ram_ebv']),
      expectedEbvOffspring: _parseEbvMap(json['expected_ebv_offspring']),
      scores: RecommendationScore.fromJson(json['scores']),
    );
  }

  static Map<String, double> _parseEbvMap(Map<String, dynamic> map) {
    return map.map((k, v) => MapEntry(k, (v as num).toDouble()));
  }
}

class RecommendationSheep {
  final int id;
  final String eartag;
  final String gender;
  final String? breed;

  const RecommendationSheep({
    required this.id,
    required this.eartag,
    required this.gender,
    this.breed,
  });

  factory RecommendationSheep.fromJson(Map<String, dynamic> json) {
    return RecommendationSheep(
      id: json['id'] as int,
      eartag: json['eartag'] as String,
      gender: json['gender'] as String,
      breed: json['breed'] as String?,
    );
  }
}

class RecommendationScore {
  final double genetic;
  final double growth;
  final double health;
  final double final_;

  const RecommendationScore({
    required this.genetic,
    required this.growth,
    required this.health,
    required this.final_,
  });

  factory RecommendationScore.fromJson(Map<String, dynamic> json) {
    return RecommendationScore(
      genetic: (json['genetic'] as num).toDouble(),
      growth: (json['growth'] as num).toDouble(),
      health: (json['health'] as num).toDouble(),
      final_: (json['final'] as num).toDouble(),
    );
  }
}
