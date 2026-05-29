class SheepHealthStats {
  final int healthyTotal;
  final int sickTotal;

  SheepHealthStats({required this.healthyTotal, required this.sickTotal});

  factory SheepHealthStats.fromJson(Map<String, dynamic> json) {
    return SheepHealthStats(
      healthyTotal: json['healthy_total'] ?? 0,
      sickTotal: json['sick_total'] ?? 0,
    );
  }
}
