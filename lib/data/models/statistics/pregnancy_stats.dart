class PregnancyStats {
  final int pregnantSheep;
  final int gaveBirth;
  final int miscarriages;

  PregnancyStats({
    required this.pregnantSheep,
    required this.gaveBirth,
    required this.miscarriages,
  });

  factory PregnancyStats.fromJson(Map<String, dynamic> json) {
    return PregnancyStats(
      pregnantSheep: json['pregnant_sheep'] ?? 0,
      gaveBirth: json['gave_birth'] ?? 0,
      miscarriages: json['miscarriages'] ?? 0,
    );
  }
}
