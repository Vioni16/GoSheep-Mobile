import 'package:dio/dio.dart';
import 'package:gosheep_mobile/data/api_client.dart';
import 'package:gosheep_mobile/data/exceptions/api_exception.dart';
import 'package:gosheep_mobile/data/exceptions/error_handler.dart';
import 'package:gosheep_mobile/data/models/api_response.dart';
import 'package:gosheep_mobile/data/models/sheep_health_stats.dart';

class SheepStatsService {
  final Dio _dio = ApiClient.dio;

  Future<SheepHealthStats> getSheepHealthStats() async {
    try {
      final response = await _dio.get('/sheep/health-stats');

      final apiResponse = ApiResponse<SheepHealthStats>.fromJson(
        response.data,
            (data) => SheepHealthStats.fromJson(data),
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