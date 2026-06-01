import 'package:gosheep_mobile/data/models/recorded_by.dart';

class Health {
  final int id;
  final int sheepId;
  final RecordedBy? recordedBy;
  final DateTime recordedAt;
  final String category;
  final String condition;
  final String severity;
  final String source;
  final String? notes;

  Health({
    required this.id,
    required this.sheepId,
    required this.recordedBy,
    required this.recordedAt,
    required this.category,
    required this.condition,
    required this.severity,
    required this.source,
    required this.notes,
  });

  factory Health.fromJson(Map<String, dynamic> json) {
    return Health(
      id: json['id'],
      sheepId: json['sheep_id'],
      recordedBy: RecordedBy.fromJson(json['recorded_by']),
      recordedAt: DateTime.parse(json['recorded_at']),
      category: json['category'],
      condition: json['condition'],
      severity: json['severity'],
      source: json['source'],
      notes: json['notes'],
    );
  }
}
