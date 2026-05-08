class CageOption {
  final int id;
  final String name;
  final int currentCapacity;
  final int maxCapacity;

  const CageOption({
    required this.id,
    required this.name,
    required this.currentCapacity,
    required this.maxCapacity,
  });

  factory CageOption.fromJson(Map<String, dynamic> json) {
    return CageOption(
      id: json['id'],
      name: json['name'],
      currentCapacity: json['current_capacity'],
      maxCapacity: json['max_capacity'],
    );
  }

  bool get isFull => currentCapacity >= maxCapacity;

  String get capacityLabel => '$currentCapacity/$maxCapacity';

  @override
  String toString() => name;
}
