class InactiveSheepStats {
  final int soldTotal;
  final int deadTotal;
  final int inactiveTotal;

  InactiveSheepStats({
    required this.soldTotal,
    required this.deadTotal,
    required this.inactiveTotal,
  });

  factory InactiveSheepStats.fromJson(Map<String, dynamic> json) {
    return InactiveSheepStats(
      soldTotal: json['sold_total'] ?? 0,
      deadTotal: json['dead_total'] ?? 0,
      inactiveTotal: json['inactive_total'] ?? 0,
    );
  }
}
