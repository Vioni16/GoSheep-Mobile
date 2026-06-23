class FarmReport {
  final ReportSummary summary;
  final List<MonthPopulation> populationPerMonth;
  final List<AgeGroup> ageDistribution;
  final HealthStats healthStats;

  const FarmReport({
    required this.summary,
    required this.populationPerMonth,
    required this.ageDistribution,
    required this.healthStats,
  });

  factory FarmReport.fromJson(Map<String, dynamic> json) {
    return FarmReport(
      summary: ReportSummary.fromJson(json['summary']),
      populationPerMonth: (json['population_per_month'] as List)
          .map((e) => MonthPopulation.fromJson(e))
          .toList(),
      ageDistribution: (json['age_distribution'] as List)
          .map((e) => AgeGroup.fromJson(e))
          .toList(),
      healthStats: HealthStats.fromJson(json['health_stats']),
    );
  }
}

class ReportSummary {
  final int totalSheep;
  final int totalCages;
  final double healthyPercentage;
  final int breedingTotal;

  const ReportSummary({
    required this.totalSheep,
    required this.totalCages,
    required this.healthyPercentage,
    required this.breedingTotal,
  });

  factory ReportSummary.fromJson(Map<String, dynamic> json) {
    return ReportSummary(
      totalSheep: json['total_sheep'] as int,
      totalCages: json['total_cages'] as int,
      healthyPercentage: (json['healthy_percentage'] as num).toDouble(),
      breedingTotal: json['breeding_total'] as int,
    );
  }
}

class MonthPopulation {
  final String month;
  final int total;

  const MonthPopulation({required this.month, required this.total});

  factory MonthPopulation.fromJson(Map<String, dynamic> json) {
    return MonthPopulation(
      month: json['month'] as String,
      total: json['total'] as int,
    );
  }
}

class AgeGroup {
  final String range;
  final int total;

  const AgeGroup({required this.range, required this.total});

  factory AgeGroup.fromJson(Map<String, dynamic> json) {
    return AgeGroup(
      range: json['range'] as String,
      total: json['total'] as int,
    );
  }
}

class HealthStats {
  final int healthyTotal;
  final int atRiskTotal;
  final int sickTotal;

  const HealthStats({
    required this.healthyTotal,
    required this.atRiskTotal,
    required this.sickTotal,
  });

  factory HealthStats.fromJson(Map<String, dynamic> json) {
    return HealthStats(
      healthyTotal: json['healthy_total'] as int,
      atRiskTotal: json['at_risk_total'] as int,
      sickTotal: json['sick_total'] as int,
    );
  }
}