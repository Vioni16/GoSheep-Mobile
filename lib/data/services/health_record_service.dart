import 'package:dio/dio.dart';
import 'package:gosheep_mobile/data/api_client.dart';
import 'package:gosheep_mobile/data/exceptions/error_handler.dart';
import 'package:gosheep_mobile/data/exceptions/api_exception.dart';
import 'package:gosheep_mobile/data/models/api_response.dart';
import 'package:gosheep_mobile/data/models/cursor_response.dart';
import 'package:gosheep_mobile/data/models/health.dart';
import 'package:gosheep_mobile/data/models/health_record.dart';
import 'package:gosheep_mobile/data/models/sheep_health_overview.dart';

class HealthRecordService {
  final Dio _dio = ApiClient.dio;

  Future<CursorResponse<SheepHealthOverview>> getSheepHealth({
    int? lastId,
    int limit = 10,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{'limit': limit};

      if (lastId != null) {
        queryParams['last_id'] = lastId;
      }

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _dio.get(
        '/health-records',
        queryParameters: queryParams,
      );

      final result = CursorResponse<SheepHealthOverview>.fromJson(
        response.data,
        (e) => SheepHealthOverview.fromJson(e),
      );

      if (!result.success) {
        throw ApiException(result.message);
      }

      return result;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<ApiResponse<Health>> createHealthRecord({
    required int sheepId,
    required String condition,
    required String category,
    required String severity,
    String? notes,
  }) async {
    try {
      final response = await _dio.post(
        '/health-records',
        data: {
          'sheep_id': sheepId,
          'condition': condition,
          'category': category,
          'severity': severity,
          if (notes != null) 'notes': notes,
        },
      );

      final result = ApiResponse.fromJson(
        response.data,
        (data) => Health.fromJson(data),
      );

      if (!result.success) {
        throw ApiException(result.message);
      }

      return result;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<CursorResponse<HealthRecord>> getHealthRecord({
    required int sheepId,
    int? lastId,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{'limit': limit};

      if (lastId != null) {
        queryParams['last_id'] = lastId;
      }

      final response = await _dio.get(
        '/health-records/$sheepId',
        queryParameters: queryParams,
      );

      final result = CursorResponse<HealthRecord>.fromJson(
        response.data,
        (e) => HealthRecord.fromJson(e),
      );

      if (!result.success) {
        throw ApiException(result.message);
      }

      return result;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<ApiResponse<Health>> updateHealthRecord({
    required int recordId,
    String? condition,
    String? category,
    String? severity,
    String? notes,
  }) async {
    try {
      final response = await _dio.put(
        '/health-records/$recordId',
        data: {
          if (condition != null) 'condition': condition,
          if (category != null) 'category': category,
          if (severity != null) 'severity': severity,
          'notes': notes,
        },
      );

      final result = ApiResponse.fromJson(
        response.data,
        (data) => Health.fromJson(data),
      );

      if (!result.success) {
        throw ApiException(result.message);
      }

      return result;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
