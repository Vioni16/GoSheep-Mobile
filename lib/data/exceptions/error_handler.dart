import 'package:dio/dio.dart';
import 'package:gosheep_mobile/data/exceptions/api_exception.dart';
import 'package:gosheep_mobile/data/exceptions/validation_exception.dart';

class ErrorHandler {
  static Exception handle(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return ApiException('Tidak ada koneksi internet');
    }

    final data = e.response?.data;

    if (e.response?.statusCode == 422 && data is Map<String, dynamic>) {
      return ValidationException.fromJson(data);
    }

    if (data is Map<String, dynamic>) {
      if (data['message'] != null) {
        return ApiException(data['message']);
      }
    }

    return ApiException('Terjadi kesalahan');
  }
}
