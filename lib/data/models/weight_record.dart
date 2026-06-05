import 'package:gosheep_mobile/data/models/weight.dart';

class WeightRecord {
  final int id;
  final List<Weight> weightRecords;

  WeightRecord({required this.id, required this.weightRecords});

  factory WeightRecord.fromJson(Map<String, dynamic> json) {
    return WeightRecord(
      id: json['id'],
      weightRecords: (json['weight_records'] as List)
          .map((e) => Weight.fromJson(e))
          .toList(),
    );
  }
}
