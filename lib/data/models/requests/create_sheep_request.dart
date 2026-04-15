class CreateSheepRequest {
  final String earTag;
  final String gender;
  final DateTime birthDate;
  final String earTagColor;
  final int breedId;
  final int sireId;
  final int damId;
  final int cageId;

  const CreateSheepRequest({
    required this.earTag,
    required this.gender,
    required this.birthDate,
    required this.earTagColor,
    required this.breedId,
    required this.sireId,
    required this.damId,
    required this.cageId
  });


  Map<String, dynamic> toJson() {
    return {
      'ear_tag': earTag,
      'gender': gender,
      'birth_date': birthDate.toIso8601String(),
      'ear_tag_color': earTagColor,
      'breed_id': breedId,
      'sire_id': sireId,
      'dam_id': damId,
      'cage_id': cageId,
    };
  }
}