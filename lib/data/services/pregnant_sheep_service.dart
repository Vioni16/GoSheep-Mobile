import 'package:dio/dio.dart';
import 'package:gosheep_mobile/data/api_client.dart';
import 'package:gosheep_mobile/data/exceptions/api_exception.dart';
import 'package:gosheep_mobile/data/exceptions/error_handler.dart';
import 'package:gosheep_mobile/data/models/api_response.dart';
import 'package:gosheep_mobile/data/models/cursor_response.dart';
import 'package:gosheep_mobile/data/models/pregnancy.dart';
import 'package:gosheep_mobile/data/models/statistics/pregnancy_stats.dart';

class PregnantSheepService {
  final Dio _dio = ApiClient.dio;

  Future<CursorResponse<Pregnancy>> getPregnancies({
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
        '/sheep-pregnancies',
        queryParameters: queryParams,
      );

      final result = CursorResponse<Pregnancy>.fromJson(
        response.data,
        (e) => Pregnancy.fromJson(e),
      );

      if (!result.success) {
        throw ApiException(result.message);
      }

      return result;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<PregnancyStats> getSummary() async {
    try {
      final response = await _dio.get('/sheep-pregnancies/summary');

      final apiResponse = ApiResponse<PregnancyStats>.fromJson(
        response.data,
        (data) => PregnancyStats.fromJson(data),
      );

      if (!apiResponse.success) {
        throw ApiException(apiResponse.message);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<Pregnancy> updatePregnancy(
    int id, {
    required String expectedBirthDate,
    required String status,
    String? endDate,
    String? notes,
    int? totalLambs,
    String? birthNotes,
  }) async {
    try {
      final data = <String, dynamic>{
        'expected_birth_date': expectedBirthDate,
        'status': status,
        'notes': notes,
      };

      if (endDate != null) {
        data['end_date'] = endDate;
      }

      if (totalLambs != null) {
        data['total_lambs'] = totalLambs;
      }

      if (birthNotes != null && birthNotes.isNotEmpty) {
        data['birth_notes'] = birthNotes;
      }

      final response = await _dio.put(
        '/sheep-pregnancies/$id',
        data: data,
      );

      final apiResponse = ApiResponse<Pregnancy>.fromJson(
        response.data,
        (data) => Pregnancy.fromJson(data),
      );

      if (!apiResponse.success) {
        throw ApiException(apiResponse.message);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}

