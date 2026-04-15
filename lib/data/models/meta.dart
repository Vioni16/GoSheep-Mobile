class Meta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const Meta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      perPage: int.parse(json['per_page'].toString()),
      total: json['total'],
    );
  }
}