import 'package:dio/dio.dart';
import 'package:gosheep_mobile/data/api_client.dart';
import 'package:gosheep_mobile/data/exceptions/api_exception.dart';
import 'package:gosheep_mobile/data/exceptions/error_handler.dart';
import 'package:gosheep_mobile/data/models/api_response.dart';
import 'package:gosheep_mobile/data/models/mating_check.dart';

class MatingCheckService {
  final Dio _dio = ApiClient.dio;

  Future<ApiResponse<List<MatingCheck>>> getMatingChecks(int matingId) async {
    try {
      final response = await _dio.get('/mating-records/check/$matingId');

      final result = ApiResponse<List<MatingCheck>>.fromJson(
        response.data,
        (data) => (data as List).map((e) => MatingCheck.fromJson(e)).toList(),
      );

      if (!result.success) {
        throw ApiException(result.message);
      }

      return result;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<ApiResponse<MatingCheck>> createMatingCheck({
    required int matingId,
    required String checkDate,
    required String result,
    String? notes,
    String? expectedBirthDate,
  }) async {
    try {
      final response = await _dio.post(
        '/mating-records/check/$matingId',
        data: {
          'check_date': checkDate,
          'result': result,
          if (notes != null) 'notes': notes,
          if (expectedBirthDate != null) 'expected_birth_date': expectedBirthDate,
        },
      );

      final apiResult = ApiResponse<MatingCheck>.fromJson(
        response.data,
        (data) => MatingCheck.fromJson(data),
      );

      if (!apiResult.success) {
        throw ApiException(apiResult.message);
      }

      return apiResult;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<ApiResponse<MatingCheck>> updateMatingCheck({
    required int matingCheckId,
    required String checkDate,
    required String result,
    String? notes,
    String? expectedBirthDate,
  }) async {
    try {
      final response = await _dio.put(
        '/mating-records/check/$matingCheckId',
        data: {
          'check_date': checkDate,
          'result': result,
          'notes': notes,
          if (expectedBirthDate != null) 'expected_birth_date': expectedBirthDate,
        },
      );

      final apiResult = ApiResponse<MatingCheck>.fromJson(
        response.data,
        (data) => MatingCheck.fromJson(data),
      );

      if (!apiResult.success) {
        throw ApiException(apiResult.message);
      }

      return apiResult;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
