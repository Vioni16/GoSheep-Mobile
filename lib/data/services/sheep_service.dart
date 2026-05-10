import 'package:dio/dio.dart';
import 'package:gosheep_mobile/data/api_client.dart';
import 'package:gosheep_mobile/data/exceptions/error_handler.dart';
import 'package:gosheep_mobile/data/models/api_response.dart';
import 'package:gosheep_mobile/data/exceptions/api_exception.dart';
import 'package:gosheep_mobile/data/models/cursor_response.dart';
import 'package:gosheep_mobile/data/models/sheep.dart';
import 'package:gosheep_mobile/data/models/sheep_detail.dart';

class SheepService {
  final Dio _dio = ApiClient.dio;

  Future<CursorResponse<Sheep>> getSheep({
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

      final response = await _dio.get('/sheep', queryParameters: queryParams);

      final result = CursorResponse<Sheep>.fromJson(
        response.data,
        (e) => Sheep.fromJson(e),
      );

      if (!result.success) {
        throw ApiException(result.message);
      }

      return result;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<SheepDetail> getSheepDetails(int sheepId) async {
    try {
      final response = await _dio.get('/sheep/$sheepId');

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (data) => SheepDetail.fromJson(data),
      );

      if (!apiResponse.success) {
        throw ApiException(apiResponse.message);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<String> deleteSheep(int sheepId) async {
    try {
      final response = await _dio.delete('/sheep/$sheepId');

      final apiResponse = ApiResponse<Null>.fromJson(
        response.data,
        (_) => null,
      );

      if (!apiResponse.success) {
        throw ApiException(apiResponse.message);
      }

      return apiResponse.message;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
