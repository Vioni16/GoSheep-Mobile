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

  static String formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}.${dt.minute.toString().padLeft(2, '0')}';
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
    const connectionErrors = [
      'Tidak ada koneksi internet',
      'Tidak dapat terhubung ke server',
      'Server terlalu lama merespons',
    ];

    return connectionErrors.any(err.contains);
  }

  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}j';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}h';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}mgg';
    } else {
      return formatDateTime(dateTime);
    }
  }

  static String formatDateShort(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Ags',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
