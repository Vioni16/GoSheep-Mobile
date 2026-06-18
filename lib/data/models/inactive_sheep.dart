enum SheepStatus { sold, dead, inactive }

class InactiveSheep {
  final int id;
  final String earTag;
  final String gender;
  final String breed;
  final String cage;
  final double weightKg;
  final String age;
  final String birthDate;
  final SheepStatus status;

  const InactiveSheep({
    required this.id,
    required this.earTag,
    required this.gender,
    required this.breed,
    required this.cage,
    required this.weightKg,
    required this.age,
    required this.birthDate,
    required this.status,
  });

  factory InactiveSheep.fromJson(Map<String, dynamic> json) {
    return InactiveSheep(
      id: json['id'] ?? 0,
      earTag: json['ear_tag'] ?? '-',
      gender: json['gender'] ?? '-',
      breed: json['breed'] ?? '-',
      cage: json['cage'] ?? '-',
      weightKg: (json['weight_kg'] as num?)?.toDouble() ?? 0.0,
      age: json['age'] ?? '-',
      birthDate: json['birth_date'] ?? '-',
      status: SheepStatus.values.firstWhere(
        (e) =>
            e.name.toLowerCase() ==
            (json['status'] as String? ?? '').toLowerCase(),
        orElse: () => SheepStatus.inactive,
      ),
    );
  }
}
