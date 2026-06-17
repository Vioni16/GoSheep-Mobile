import 'package:flutter/material.dart';
import 'package:gosheep_mobile/data/models/recorded_by.dart';

sealed class ActivityProperties {}

class CreatedProperties extends ActivityProperties {
  final Map<String, dynamic> data;

  CreatedProperties(this.data);

  factory CreatedProperties.fromJson(Map<String, dynamic> json) =>
      CreatedProperties(Map<String, dynamic>.from(json));

  String? get(String key) => data[key]?.toString();
}

class UpdatedProperties extends ActivityProperties {
  final Map<String, dynamic> old;
  final Map<String, dynamic> next;

  UpdatedProperties({required this.old, required this.next});

  factory UpdatedProperties.fromJson(Map<String, dynamic> json) =>
      UpdatedProperties(
        old: Map<String, dynamic>.from(json['old'] ?? {}),
        next: Map<String, dynamic>.from(json['new'] ?? {}),
      );

  List<String> get changes {
    return next.entries
        .where((e) => old[e.key]?.toString() != e.value?.toString())
        .map((e) => '${label(e.key)}: ${old[e.key]} → ${e.value}')
        .toList();
  }

  static String label(String key) {
    const labels = {
      'weight': 'Berat (Kg)',
      'breed': 'Ras',
      'cage': 'Kandang',
      'gender': 'Jenis Kelamin',
      'condition': 'Kondisi',
      'severity': 'Tingkat',
      'category': 'Kategori',
      'notes': 'Catatan',
      'result': 'Hasil',
      'check_date': 'Tanggal Pemeriksaan',
    };
    return labels[key] ?? key;
  }
}

class DeletedProperties extends ActivityProperties {
  final Map<String, dynamic> snapshot;

  DeletedProperties(this.snapshot);

  factory DeletedProperties.fromJson(Map<String, dynamic> json) =>
      DeletedProperties(Map<String, dynamic>.from(json['snapshot'] ?? {}));

  String? get(String key) => snapshot[key]?.toString();
}

class ActivityFeed {
  final int id;
  final RecordedBy? user;
  final int loggableId;
  final String action; // created, updated, deleted
  final String entity;
  final String description;
  final ActivityProperties? properties;
  final DateTime createdAt;

  ActivityFeed({
    required this.id,
    required this.user,
    required this.loggableId,
    required this.action,
    required this.entity,
    required this.description,
    this.properties,
    required this.createdAt,
  });

  factory ActivityFeed.fromJson(Map<String, dynamic> json) {
    return ActivityFeed(
      id: json['id'],
      user: json['user'] != null ? RecordedBy.fromJson(json['user']) : null,
      loggableId: json['loggable_id'],
      action: json['action'],
      entity: json['entity'],
      description: json['description'],
      properties: _parseProperties(json['action'], json['properties']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  static ActivityProperties? _parseProperties(String action, dynamic raw) {
    if (raw == null) return null;
    final map = Map<String, dynamic>.from(raw);

    return switch (action) {
      'created' => CreatedProperties.fromJson(map),
      'updated' => UpdatedProperties.fromJson(map),
      'deleted' => DeletedProperties.fromJson(map),
      _ => null,
    };
  }

  String get userInitials {
    final name = user?.name ?? '';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Color get avatarColor => switch (action) {
    'created' => const Color(0xFF0F5132),
    'updated' => const Color(0xFF185FA5),
    'deleted' => Colors.red.shade700,
    _ => Colors.grey.shade600,
  };

  String get actionLabel => switch (action) {
    'created' => 'menambahkan',
    'updated' => 'memperbarui',
    'deleted' => 'menghapus',
    _ => action,
  };

  bool get canNavigate => action != 'deleted';
}
