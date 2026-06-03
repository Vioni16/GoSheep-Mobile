import 'package:gosheep_mobile/data/models/recorded_by.dart';

class Weight {
  final int id;
  final double weight;
  final RecordedBy? recordedBy;
  final DateTime recordedAt;

  Weight({
    required this.id,
    required this.weight,
    required this.recordedBy,
    required this.recordedAt,
  });

  factory Weight.fromJson(Map<String, dynamic> json) {
    return Weight(
      id: json['id'],
      weight: (json['weight'] as num).toDouble(),
      recordedBy: json['recorded_by'] != null
          ? RecordedBy.fromJson(json['recorded_by'])
          : null,
      recordedAt: DateTime.parse(json['recorded_at']),
    );
  }
}
