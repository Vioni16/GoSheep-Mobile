import 'package:gosheep_mobile/data/models/recorded_by.dart';

class Health {
  final int id;
  final RecordedBy? recordedBy;
  final DateTime recordedAt;
  final String category;
  final String condition;
  final String severity;
  final String source;
  final String? notes;

  Health({
    required this.id,
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
      recordedBy: json['recorded_by'] != null
          ? RecordedBy.fromJson(json['recorded_by'])
          : null,
      recordedAt: DateTime.parse(json['recorded_at']),
      category: json['category'],
      condition: json['condition'],
      severity: json['severity'],
      source: json['source'],
      notes: json['notes'],
    );
  }

  Health copyWith({
    RecordedBy? recordedBy,
    DateTime? recordedAt,
    String? category,
    String? condition,
    String? severity,
    String? source,
    String? notes,
  }) {
    return Health(
      id: id,
      recordedBy: recordedBy ?? this.recordedBy,
      recordedAt: recordedAt ?? this.recordedAt,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      severity: severity ?? this.severity,
      source: source ?? this.source,
      notes: notes ?? this.notes,
    );
  }
}
