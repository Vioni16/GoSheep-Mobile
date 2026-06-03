class WeightStatistic {
  final int year;
  final List<WeightMonth> statistics;

  WeightStatistic({required this.year, required this.statistics});

  factory WeightStatistic.fromJson(Map<String, dynamic> json) {
    return WeightStatistic(
      year: json['year'] as int,
      statistics: (json['statistics'] as List)
          .map((stat) => WeightMonth.fromJson(stat))
          .toList(),
    );
  }
}

class WeightMonth {
  final int month;
  final String monthName;
  final double? avgWeight;

  WeightMonth({required this.month, required this.monthName, this.avgWeight});

  factory WeightMonth.fromJson(Map<String, dynamic> json) {
    return WeightMonth(
      month: json['month'] as int,
      monthName: json['month_name'] as String,
      avgWeight: json['avg_weight'] == null
          ? null
          : (json['avg_weight'] as num).toDouble(),
    );
  }

  bool get hasData => avgWeight != null && avgWeight! > 0;
}
