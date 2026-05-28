class MatingRecordStats {
  final int pregnantTotal;
  final int unknownTotal;
  final int notPregnantTotal;
  final int failedTotal;

  MatingRecordStats({
    required this.pregnantTotal,
    required this.unknownTotal,
    required this.notPregnantTotal,
    required this.failedTotal,
  });

  factory MatingRecordStats.fromJson(Map<String, dynamic> json) {
    return MatingRecordStats(
      pregnantTotal: json['pregnant_total'],
      unknownTotal: json['unknown_total'],
      notPregnantTotal: json['not_pregnant_total'],
      failedTotal: json['failed_total'],
    );
  }
}
