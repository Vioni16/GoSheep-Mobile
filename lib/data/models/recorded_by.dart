class RecordedBy {
  final int id;
  final String name;

  RecordedBy({required this.id, required this.name});

  factory RecordedBy.fromJson(Map<String, dynamic> json) {
    return RecordedBy(id: json['id'], name: json['name']);
  }
}
