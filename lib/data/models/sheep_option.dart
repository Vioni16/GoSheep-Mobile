class SheepOption {
  final int id;
  final String label;

  const SheepOption({required this.id, required this.label});

  factory SheepOption.fromBreedJson(Map<String, dynamic> json) {
    return SheepOption(id: json['id'], label: json['name']);
  }

  factory SheepOption.fromSireDamJson(Map<String, dynamic> json) {
    return SheepOption(id: json['id'], label: json['eartag']);
  }
}
