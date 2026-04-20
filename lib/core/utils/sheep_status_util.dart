import 'package:flutter/material.dart';

class SheepStatusUtil {
  static bool isHealthy(String status) {
    return status == 'sehat';
  }

  static bool isAtRisk(String status) {
    return status == 'at_risk';
  }

  static String healthConditionStatus(String status) {
    if (status == 'heat_stress_risk') return 'Potensi Stress Panas';

    return status;
  }

  static Color getHealthColor(String status) {
    if (isHealthy(status)) {
      return const Color(0xFF1B5E20);
    } else if (isAtRisk(status)) {
      return const Color(0xFF854F0B);
    } else {
      return const Color(0xFFA32D2D);
    }
  }

  static String getHealthLabel(String status) {
    if (isHealthy(status)) {
      return 'Sehat';
    } else if (isAtRisk(status)) {
      return 'Berisiko';
    } else {
      return 'Sakit';
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