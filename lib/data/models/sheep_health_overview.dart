import 'package:gosheep_mobile/data/models/health.dart';

class SheepHealthOverview {
  final int sheepId;
  final String earTag;
  final String gender;
  final Health latestHealth;

  SheepHealthOverview({
    required this.sheepId,
    required this.earTag,
    required this.gender,
    required this.latestHealth,
  });

  factory SheepHealthOverview.fromJson(Map<String, dynamic> json) {
    return SheepHealthOverview(
      sheepId: json['id'],
      earTag: json['eartag'],
      gender: json['gender'],
      latestHealth: Health.fromJson(json['latest_health']),
    );
  }
}
