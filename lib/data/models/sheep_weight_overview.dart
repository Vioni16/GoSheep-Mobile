import 'package:gosheep_mobile/data/models/weight.dart';

class SheepWeightOverview {
  final int id;
  final String earTag;
  final String gender;
  final Weight latestWeight;

  SheepWeightOverview({
    required this.id,
    required this.earTag,
    required this.gender,
    required this.latestWeight,
  });

  factory SheepWeightOverview.fromJson(Map<String, dynamic> json) {
    return SheepWeightOverview(
      id: json['id'],
      earTag: json['eartag'],
      gender: json['gender'],
      latestWeight: Weight.fromJson(json['latest_weight']),
    );
  }
}
