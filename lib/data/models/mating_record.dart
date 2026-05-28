import 'package:gosheep_mobile/core/enums/mating_result_enum.dart';

class MatingRecord {
  final int id;
  final int eweId;
  final int ramId;
  final String eweEarTag;
  final String ramEarTag;
  final DateTime matingDate;
  final DateTime? endDate;
  final MatingResult result;

  MatingRecord({
    required this.id,
    required this.eweId,
    required this.ramId,
    required this.eweEarTag,
    required this.ramEarTag,
    required this.matingDate,
    required this.endDate,
    required this.result,
  });

  factory MatingRecord.fromJson(Map<String, dynamic> json) {
    return MatingRecord(
      id: json['id'],
      eweId: json['ewe_id'],
      ramId: json['ram_id'],
      eweEarTag: json['ewe_ear_tag'],
      ramEarTag: json['ram_ear_tag'],
      matingDate: DateTime.parse(json['mating_date']),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : null,
      result: MatingResult.fromString(json['result']),
    );
  }
}
