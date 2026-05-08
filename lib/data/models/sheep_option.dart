class SheepOption {
  final int id;
  final String label;

  const SheepOption({required this.id, required this.label});

  factory SheepOption.fromJson(Map<String, dynamic> json) {
    return SheepOption(id: json['id'], label: json['label']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'label': label};
  }

  @override
  String toString() => label;
}
