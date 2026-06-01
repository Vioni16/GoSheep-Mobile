class HealthRecordStatistic {
  final int totalRecords;
  final int recordsThisWeek;
  final String? topCategoryName;
  final int topCategoryTotal;
  final int severityNormal;
  final int severityMild;
  final int severityModerate;
  final int severitySevere;

  const HealthRecordStatistic({
    required this.totalRecords,
    required this.recordsThisWeek,
    required this.topCategoryName,
    required this.topCategoryTotal,
    required this.severityNormal,
    required this.severityMild,
    required this.severityModerate,
    required this.severitySevere,
  });

  factory HealthRecordStatistic.fromJson(Map<String, dynamic> json) {
    final topCategory = json['top_category'] as Map<String, dynamic>? ?? {};
    final severityStats = json['severity_statistics'] as Map<String, dynamic>? ?? {};

    return HealthRecordStatistic(
      totalRecords: json['total_records'] ?? 0,
      recordsThisWeek: json['records_this_week'] ?? 0,
      topCategoryName: topCategory['name'],
      topCategoryTotal: topCategory['total'] ?? 0,
      severityNormal: severityStats['normal'] ?? 0,
      severityMild: severityStats['mild'] ?? 0,
      severityModerate: severityStats['moderate'] ?? 0,
      severitySevere: severityStats['severe'] ?? 0,
    );
  }
}
