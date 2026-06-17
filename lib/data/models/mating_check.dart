class MatingCheck {
  final int id;
  final int matingRecordId;
  final DateTime checkDate;
  final String? notes;
  final DateTime? expectedBirthDate;
  final DateTime createdAt;

  MatingCheck({
    required this.id,
    required this.matingRecordId,
    required this.checkDate,
    this.notes,
    this.expectedBirthDate,
    required this.createdAt,
  });

  factory MatingCheck.fromJson(Map<String, dynamic> json) {
    return MatingCheck(
      id: json['id'],
      matingRecordId: json['mating_record_id'],
      checkDate: DateTime.parse(json['check_date']).toLocal(),
      notes: json['notes'],
      expectedBirthDate: json['expected_birth_date'] != null
          ? DateTime.parse(json['expected_birth_date']).toLocal()
          : null,
      createdAt: DateTime.parse(json['created_at']).toLocal(),
    );
  }
}
