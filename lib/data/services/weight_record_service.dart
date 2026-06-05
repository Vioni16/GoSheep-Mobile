import 'package:dio/dio.dart';
import 'package:gosheep_mobile/data/api_client.dart';
import 'package:gosheep_mobile/data/exceptions/api_exception.dart';
import 'package:gosheep_mobile/data/exceptions/error_handler.dart';
import 'package:gosheep_mobile/data/models/api_response.dart';
import 'package:gosheep_mobile/data/models/cursor_response.dart';
import 'package:gosheep_mobile/data/models/sheep_weight_overview.dart';
import 'package:gosheep_mobile/data/models/weight.dart';
import 'package:gosheep_mobile/data/models/weight_record.dart';

class WeightRecordService {
  final Dio _dio = ApiClient.dio;

  Future<CursorResponse<SheepWeightOverview>> getSheepWeight({
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
        '/sheep-weight',
        queryParameters: queryParams,
      );

      final result = CursorResponse<SheepWeightOverview>.fromJson(
        response.data,
        (e) => SheepWeightOverview.fromJson(e),
      );

      if (!result.success) {
        throw ApiException(result.message);
      }

      return result;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<CursorResponse<WeightRecord>> getWeightRecord({
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
        '/sheep-weight/$sheepId/records',
        queryParameters: queryParams,
      );

      final result = CursorResponse<WeightRecord>.fromJson(
        response.data,
        (e) => WeightRecord.fromJson(e),
      );

      if (!result.success) {
        throw ApiException(result.message);
      }

      return result;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<ApiResponse<Weight>> createWeightRecord({
    required int sheepId,
    required double weight,
  }) async {
    try {
      final response = await _dio.post(
        '/sheep-weight',
        data: {'sheep_id': sheepId, 'weight': weight},
      );

      final result = ApiResponse.fromJson(
        response.data,
        (data) => Weight.fromJson(data),
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
