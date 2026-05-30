class OverviewStats {
  final int totalSheep;
  final int pregnantSheep;
  final int upcomingBirths;
  final double pregnancyRate;

  const OverviewStats({
    required this.totalSheep,
    required this.pregnantSheep,
    required this.upcomingBirths,
    required this.pregnancyRate,
  });

  factory OverviewStats.fromJson(Map<String, dynamic> json) {
    return OverviewStats(
      totalSheep: json['total_sheep'] ?? 0,
      pregnantSheep: json['pregnant_sheep'] ?? 0,
      upcomingBirths: json['upcoming_births'] ?? 0,
      pregnancyRate: (json['pregnancy_rate'] ?? 0).toDouble(),
    );
  }
}
