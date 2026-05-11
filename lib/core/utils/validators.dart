class Validators {
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName wajib diisi';
    }

    return null;
  }

  static String? requiredDropdown(dynamic value, String fieldName) {
    if (value == null) {
      return '$fieldName wajib dipilih';
    }

    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email wajib diisi';
    }

    final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password wajib diisi';
    }

    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }

    return null;
  }

  static String? weight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Berat wajib diisi';
    }

    final parsed = double.tryParse(value.trim());

    if (parsed == null) {
      return 'Berat harus berupa angka';
    }

    if (parsed <= 0) {
      return 'Berat harus lebih dari 0';
    }

    if (parsed > 200) {
      return 'Berat maksimal 200 kg';
    }

    final decimalRegex = RegExp(r'^\d+(\.\d{1,2})?$');
    if (!decimalRegex.hasMatch(value.trim())) {
      return 'Maks 2 angka belakang koma';
    }

    return null;
  }
}
