class CageSheep {
  final int id;
  final String earTag;

  CageSheep({
    required this.id,
    required this.earTag,
  });

  factory CageSheep.fromJson(Map<String, dynamic> json) {
    return CageSheep(
      id: json['id'],
      earTag: json['eartag'],
    );
  }
}

class Cage {
  final int id;
  final String name;
  final int currentCapacity;
  final int maxCapacity;
  final String statusLabel;
  final DateTime createdAt;
  final List<CageSheep> sheep;

  Cage({
    required this.id,
    required this.name,
    required this.currentCapacity,
    required this.maxCapacity,
    required this.statusLabel,
    required this.createdAt,
    required this.sheep,
  });

  factory Cage.fromJson(Map<String, dynamic> json) {
    return Cage(
      id: json['id'],
      name: json['name'],
      currentCapacity: json['current_capacity'],
      maxCapacity: json['max_capacity'],
      statusLabel: json['status_label'],
      createdAt: DateTime.parse(json['created_at']),
      sheep: (json['sheep'] as List<dynamic>)
          .map((e) => CageSheep.fromJson(e))
          .toList(),
    );
  }
}