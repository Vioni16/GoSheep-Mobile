import 'package:dio/dio.dart';
import 'package:gosheep_mobile/data/api_client.dart';
import 'package:gosheep_mobile/data/exceptions/api_exception.dart';
import 'package:gosheep_mobile/data/exceptions/error_handler.dart';
import 'package:gosheep_mobile/data/models/api_response.dart';
import 'package:gosheep_mobile/data/models/sheep_breeding.dart';
import 'package:gosheep_mobile/data/models/recommendation.dart';

class BreedingService {
  final Dio _dio = ApiClient.dio;

  Future<ApiResponse<List<SheepBreeding>>> getSheepList(String gender) async {
    try {
      final response = await _dio.get(
        '/recommendations/sheep',
        queryParameters: {'gender': gender},
      );

      final apiResponse = ApiResponse<List<SheepBreeding>>.fromJson(
        response.data,
        (data) => (data as List).map((e) => SheepBreeding.fromJson(e)).toList(),
      );

      if (!apiResponse.success) {
        throw ApiException(apiResponse.message);
      }

      return apiResponse;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<ApiResponse<RecommendationResult>> getRecommendations(int sheepId) async {
    try {
      final response = await _dio.get('/recommendations/$sheepId');

      final apiResponse = ApiResponse<RecommendationResult>.fromJson(
        response.data,
        (data) => RecommendationResult.fromJson(data),
      );

      if (!apiResponse.success) {
        throw ApiException(apiResponse.message);
      }

      return apiResponse;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
