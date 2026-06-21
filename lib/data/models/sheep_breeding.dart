class SheepBreeding {
  final int id;
  final String eartag;
  final String gender;
  final String? breed;
  final String? eartagColor;
  final int ageDays;
  final double ageMonths;
  final bool isEligible;
  final String breedingStatus;
  final Ebv? ebv;

  const SheepBreeding({
    required this.id,
    required this.eartag,
    required this.gender,
    this.breed,
    this.eartagColor,
    required this.ageDays,
    required this.ageMonths,
    required this.isEligible,
    required this.breedingStatus,
    this.ebv,
  });

  factory SheepBreeding.fromJson(Map<String, dynamic> json) {
    return SheepBreeding(
      id: json['id'] as int,
      eartag: json['eartag'] as String,
      gender: json['gender'] as String,
      breed: json['breed'] as String?,
      eartagColor: json['eartag_color'] as String?,
      ageDays: json['age_days'] as int,
      ageMonths: (json['age_months'] as num).toDouble(),
      isEligible: json['is_eligible'] as bool,
      breedingStatus: json['breeding_status'] as String,
      ebv: json['ebv'] != null ? Ebv.fromJson(json['ebv']) : null,
    );
  }
}

class Ebv {
  final double? weight;
  final double? growth;
  final double? health;

  const Ebv({this.weight, this.growth, this.health});

  factory Ebv.fromJson(Map<String, dynamic> json) {
    return Ebv(
      weight: (json['weight'] as num?)?.toDouble(),
      growth: (json['growth'] as num?)?.toDouble(),
      health: (json['health'] as num?)?.toDouble(),
    );
  }
}
