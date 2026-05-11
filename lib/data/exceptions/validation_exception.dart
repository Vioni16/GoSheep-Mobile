class ValidationException implements Exception {
  final String message;
  final Map<String, List<String>> errors;

  ValidationException({required this.message, required this.errors});

  factory ValidationException.fromJson(Map<String, dynamic> json) {
    return ValidationException(
      message: json['message'] ?? 'Validation error',
      errors: (json['errors'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, List<String>.from(value)),
      ),
    );
  }

  String? first(String field) {
    return errors[field]?.first;
  }

  @override
  String toString() => message;
}
