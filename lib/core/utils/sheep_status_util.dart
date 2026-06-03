import 'package:flutter/material.dart';

class SheepStatusUtil {
  static bool isHealthy(String status) {
    return status == 'sehat';
  }

  static bool isStressRisk(String status) {
    return status == 'heat_stress_risk';
  }

  static bool isStressCritical(String status) {
    return status == 'heat_stress_critical';
  }

  static String healthConditionStatus(String status) {
    if (status == 'heat_stress_risk') return 'Potensi Stress Panas';

    return status;
  }

  static Color getHealthColor(String status) {
    if (isHealthy(status)) {
      return const Color(0xFF1B5E20);
    }
    return const Color(0xFFA32D2D);
  }

  static String getHealthLabel(String status) {
    if (isHealthy(status)) {
      return 'Sehat';
    } else if (isStressRisk(status)) {
      return 'Potensi Stress';
    } else if (isStressCritical(status)) {
      return 'Stress Panas';
    } else {
      return 'Sakit';
    }
  }

  static Color severityColor(String severity) {
    switch (severity) {
      case 'normal':
        return const Color(0xFF1B5E20);

      case 'ringan':
        return Color.fromARGB(255, 31, 50, 175);

      case 'sedang':
        return const Color(0xFFB8860B);

      case 'berat':
        return Colors.red.shade700;

      default:
        return Colors.grey;
    }
  }

  static String healthCategoryLabel(String category) {
    switch (category) {
      case 'health':
        return 'Kesehatan';
      case 'environment':
        return 'Lingkungan';
      case 'nutrition':
        return 'Nutrisi';
      case 'maintenance':
        return 'Perawatan';
      default:
        return '-';
    }
  }

  static String getGenderLabel(String gender) {
    switch (gender) {
      case 'male':
        return 'Jantan';
      case 'female':
        return 'Betina';
      default:
        return '-';
    }
  }

  static Color getGenderColor(String gender) {
    switch (gender) {
      case 'male':
        return Colors.blue;
      case 'female':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }
}
