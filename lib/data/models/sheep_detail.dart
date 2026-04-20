import 'package:gosheep_mobile/data/models/sheep.dart';

class ParentSheep {
  final int id;
  final String earTag;

  const ParentSheep({
    required this.id,
    required this.earTag,
  });

  factory ParentSheep.fromJson(Map<String, dynamic> json) {
    return ParentSheep(
      id: json['id'],
      earTag: json['ear_tag'],
    );
  }
}

class SheepDetail {
  final int id;
  final String earTag;
  final String earTagColor;
  final String gender;
  final String? breed;

  final DateTime birthDate;
  final String status;
  final DateTime createdAt;
  final String? cage;

  final ParentSheep? sire;
  final ParentSheep? dam;

  final double weight;
  final String healthCondition;

  final String statusUi;
  final bool isFromInitial;

  const SheepDetail({
    required this.id,
    required this.earTag,
    required this.earTagColor,
    required this.gender,
    required this.breed,
    required this.birthDate,
    required this.status,
    required this.createdAt,
    required this.cage,
    required this.sire,
    required this.dam,
    required this.weight,
    required this.healthCondition,
    required this.statusUi,
    this.isFromInitial = false,
  });

  factory SheepDetail.fromJson(Map<String, dynamic> json) {
    return SheepDetail(
      id: json['id'],
      earTag: json['ear_tag'],
      earTagColor: json['ear_tag_color'],
      gender: json['gender'],
      breed: json['breed'],

      birthDate: DateTime.parse(json['birth_date']),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      cage: json['cage'],

      sire: json['sire'] != null
          ? ParentSheep.fromJson(json['sire'])
          : null,

      dam: json['dam'] != null
          ? ParentSheep.fromJson(json['dam'])
          : null,

      weight: (json['weight'] as num).toDouble(),

      healthCondition: json['health']['condition'],

      statusUi: json['status_ui'],
      isFromInitial: false,
    );
  }

  factory SheepDetail.fromSheep(Sheep sheep) {
    return SheepDetail(
      id: sheep.id,
      earTag: sheep.earTag,
      earTagColor: sheep.earTagColor,
      gender: sheep.gender,
      breed: sheep.breed,

      birthDate: DateTime.now(),
      status: '-',
      createdAt: DateTime.now(),
      cage: null,
      sire: null,
      dam: null,

      weight: sheep.weight,
      healthCondition: '-',

      statusUi: sheep.statusUi,
      isFromInitial: true,
    );
  }
}