import 'package:gosheep_mobile/data/models/health.dart';

class SheepHealthOverview {
  final int id;
  final String earTag;
  final String gender;
  final Health latestHealth;

  SheepHealthOverview({
    required this.id,
    required this.earTag,
    required this.gender,
    required this.latestHealth,
  });

  factory SheepHealthOverview.fromJson(Map<String, dynamic> json) {
    return SheepHealthOverview(
      id: json['id'],
      earTag: json['eartag'],
      gender: json['gender'],
      latestHealth: Health.fromJson(json['latest_health']),
    );
  }
}
