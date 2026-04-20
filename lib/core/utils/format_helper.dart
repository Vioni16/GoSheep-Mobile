import 'package:intl/intl.dart';

class FormatHelper {
  static String formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd MMM yyyy', 'id_ID').format(date);
  }

  static String formatDateTime(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd MMM yyyy HH:mm', 'id_ID').format(date);
  }

  static String formatWeight(double? weight) {
    if (weight == null) return '-';
    return '${weight.toStringAsFixed(2)} kg';
  }

  static String formatNullable(String? value) {
    if (value == null || value.isEmpty) return '-';
    return value;
  }

  static String formatAge(DateTime? birthDate) {
    if (birthDate == null) return '-';

    final now = DateTime.now();

    int years = now.year - birthDate.year;
    int months = now.month - birthDate.month;
    int days = now.day - birthDate.day;

    if (days < 0) {
      final prevMonth = DateTime(now.year, now.month, 0);
      days += prevMonth.day;
      months--;
    }

    if (months < 0) {
      months += 12;
      years--;
    }

    final totalMonths = years * 12 + months;

    if (totalMonths == 0) {
      return '$days hari';
    }

    if (days == 0) {
      return '$totalMonths bulan';
    }

    return '$totalMonths bulan $days hari';
  }

  static bool isNoConnection(String err) {
    return err.contains('Tidak ada koneksi');
  }
}