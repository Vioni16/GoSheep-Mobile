class MatingPartner {
  final int id;
  final String eartag;
  final int matingRecordId;

  MatingPartner({
    required this.id,
    required this.eartag,
    required this.matingRecordId,
  });

  factory MatingPartner.fromJson(Map<String, dynamic> json) {
    return MatingPartner(
      id: json['id'],
      eartag: json['eartag'] ?? '',
      matingRecordId: json['mating_record_id'],
    );
  }
}
