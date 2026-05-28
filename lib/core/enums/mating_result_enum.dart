import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/theme/theme.dart';

enum MatingResult {
  unknown,
  pregnant,
  notPregnant,
  failed;

  factory MatingResult.fromString(String value) {
    switch (value) {
      case 'unknown':
        return MatingResult.unknown;

      case 'pregnant':
        return MatingResult.pregnant;

      case 'not_pregnant':
        return MatingResult.notPregnant;

      case 'failed':
        return MatingResult.failed;

      default:
        throw Exception('Unknown mating result: $value');
    }
  }

  String toApiValue() {
    switch (this) {
      case MatingResult.unknown:
        return 'unknown';

      case MatingResult.pregnant:
        return 'pregnant';

      case MatingResult.notPregnant:
        return 'not_pregnant';

      case MatingResult.failed:
        return 'failed';
    }
  }

  String get label {
    switch (this) {
      case MatingResult.unknown:
        return 'Belum Diketahui';

      case MatingResult.pregnant:
        return 'Bunting';

      case MatingResult.notPregnant:
        return 'Tidak Bunting';

      case MatingResult.failed:
        return 'Gagal';
    }
  }

  Color get color {
    switch (this) {
      case MatingResult.unknown:
        return Colors.orange;

      case MatingResult.pregnant:
        return AppTheme.primaryGreen;

      case MatingResult.notPregnant:
        return const Color.fromARGB(255, 31, 124, 200);

      case MatingResult.failed:
        return const Color.fromARGB(255, 156, 40, 31);
    }
  }

  IconData get icon {
    switch (this) {
      case MatingResult.unknown:
        return Icons.help_outline;

      case MatingResult.pregnant:
        return Icons.favorite;

      case MatingResult.notPregnant:
        return Icons.remove_circle_outline;

      case MatingResult.failed:
        return Icons.close_rounded;
    }
  }
}
