class PregnancyBirth {
  final int totalLambs;
  final String? birthNotes;

  PregnancyBirth({required this.totalLambs, this.birthNotes});

  factory PregnancyBirth.fromJson(Map<String, dynamic> json) {
    return PregnancyBirth(
      totalLambs: json['total_lambs'] ?? 0,
      birthNotes: json['birth_notes'],
    );
  }
}

class Pregnancy {
  final int id;
  final int matingRecordId;
  final DateTime startDate;
  final DateTime expectedBirthDate;
  final DateTime? endDate;
  final String status;
  final int eweId;
  final String eweEartag;
  final String ramEartag;
  final String? notes;
  final PregnancyBirth? birth;

  Pregnancy({
    required this.id,
    required this.matingRecordId,
    required this.startDate,
    required this.expectedBirthDate,
    this.endDate,
    required this.status,
    required this.eweId,
    required this.eweEartag,
    required this.ramEartag,
    this.notes,
    this.birth,
  });

  factory Pregnancy.fromJson(Map<String, dynamic> json) {
    final ewe = json['ewe'] ?? {};

    return Pregnancy(
      id: json['id'],
      matingRecordId: json['mating_record_id'] ?? 0,
      startDate: DateTime.parse(json['start_date']).toLocal(),
      expectedBirthDate: DateTime.parse(json['expected_birth_date']).toLocal(),
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']).toLocal() : null,
      status: json['status'] ?? 'ongoing',
      eweId: ewe['id'] ?? 0,
      eweEartag: ewe['eartag'] ?? '-',
      ramEartag: json['ram_eartag'] ?? '-',
      notes: json['notes'],
      birth: json['birth'] != null ? PregnancyBirth.fromJson(json['birth']) : null,
    );
  }
}

