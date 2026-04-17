import 'package:dio/dio.dart';
import 'api_exception.dart';

class ErrorHandler {
  static Exception handle(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return ApiException('Tidak ada koneksi internet');
    }

    final data = e.response?.data;

    final message = data is Map<String, dynamic>
        ? data['message'] ?? e.message
        : e.message;

    return ApiException(message ?? 'Terjadi kesalahan');
  }
}