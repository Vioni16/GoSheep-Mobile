import 'package:gosheep_mobile/data/models/health.dart';

class HealthRecord {
  final int id;
  final List<Health> healthRecords;

  HealthRecord({required this.id, required this.healthRecords});

  factory HealthRecord.fromJson(Map<String, dynamic> json) {
    return HealthRecord(
      id: json['id'],
      healthRecords: (json['health_records'] as List)
          .map((e) => Health.fromJson(e))
          .toList(),
    );
  }
}
