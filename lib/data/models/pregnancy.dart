class Pregnancy {
  final int id;
  final DateTime startDate;
  final DateTime expectedBirthDate;
  final String status;
  final int eweId;
  final String eweEartag;

  Pregnancy({
    required this.id,
    required this.startDate,
    required this.expectedBirthDate,
    required this.status,
    required this.eweId,
    required this.eweEartag,
  });

  factory Pregnancy.fromJson(Map<String, dynamic> json) {
    final ewe = json['ewe'] ?? {};

    return Pregnancy(
      id: json['id'],
      startDate: DateTime.parse(json['start_date']),
      expectedBirthDate: DateTime.parse(json['expected_birth_date']),
      status: json['status'] ?? 'ongoing',
      eweId: ewe['id'] ?? 0,
      eweEartag: ewe['eartag'] ?? '-',
    );
  }
}
