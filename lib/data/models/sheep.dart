class Sheep {
  final int id;
  final String earTag;
  final String earTagColor;
  final String gender;
  final String name;
  final String breed;
  final double weight;
  final String statusUi;

  const Sheep({
    required this.id,
    required this.earTag,
    required this.earTagColor,
    required this.gender,
    required this.name,
    required this.breed,
    required this.weight,
    required this.statusUi,
  });

  factory Sheep.fromJson(Map<String, dynamic> json) {
    return Sheep(
        id: json['id'],
        earTag: json['ear_tag'],
        earTagColor: json['ear_tag_color'],
        gender: json['gender'],
        name: json['name'],
        breed: json['breed'],
        weight: (json['weight'] as num).toDouble(),
        statusUi: json['status_ui'],
    );
  }
}