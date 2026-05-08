import 'package:dio/dio.dart';
import 'package:gosheep_mobile/data/api_client.dart';
import 'package:gosheep_mobile/data/exceptions/error_handler.dart';
import 'package:gosheep_mobile/data/models/api_response.dart';
import 'package:gosheep_mobile/data/exceptions/api_exception.dart';
import 'package:gosheep_mobile/data/models/sheep_detail.dart';
import '../models/sheep_response.dart';

class SheepService {
  final Dio _dio = ApiClient.dio;

  Future<SheepResponse> getSheep({
    int? lastId,
    int limit = 10,
    String? search,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {'limit': limit};

      if (lastId != null) {
        queryParams['last_id'] = lastId;
      }

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _dio.get('/sheep', queryParameters: queryParams);

      final apiResponse = SheepResponse.fromJson(response.data);

      if (!apiResponse.success) {
        throw ApiException(apiResponse.message);
      }

      return apiResponse;
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
