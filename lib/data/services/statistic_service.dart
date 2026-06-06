import 'package:dio/dio.dart';
import 'package:gosheep_mobile/data/api_client.dart';
import 'package:gosheep_mobile/data/exceptions/api_exception.dart';
import 'package:gosheep_mobile/data/exceptions/error_handler.dart';
import 'package:gosheep_mobile/data/models/api_response.dart';
import 'package:gosheep_mobile/data/models/health_record_statistic.dart';
import 'package:gosheep_mobile/data/models/statistics/mating_record_stats.dart';
import 'package:gosheep_mobile/data/models/statistics/overview_stats.dart';
import 'package:gosheep_mobile/data/models/statistics/sheep_health_stats.dart';
import 'package:gosheep_mobile/data/models/statistics/weight_statistic.dart';

class StatisticService {
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

  Future<MatingRecordStats> getMatingRecStats() async {
    try {
      final response = await _dio.get('/mating-records/stats');

      final apiResponse = ApiResponse<MatingRecordStats>.fromJson(
        response.data,
        (data) => MatingRecordStats.fromJson(data),
      );

      if (!apiResponse.success) {
        throw ApiException(apiResponse.message);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<OverviewStats> getOverviewStats() async {
    try {
      final response = await _dio.get('/statistics/overview');

      final apiResponse = ApiResponse<OverviewStats>.fromJson(
        response.data,
        (data) => OverviewStats.fromJson(data),
      );

      if (!apiResponse.success) {
        throw ApiException(apiResponse.message);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<HealthRecordStatistic> getHealthRecordStatistics() async {
    try {
      final response = await _dio.get('/health-records/statistics');

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (data) => HealthRecordStatistic.fromJson(data),
      );

      if (!apiResponse.success) {
        throw ApiException(apiResponse.message);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<WeightStatistic> getAllWeightStatistics({int? year}) async {
    try {
      final params = <String, dynamic>{};
      if (year != null) {
        params['year'] = year;
      }

      final response = await _dio.get(
        '/sheep-weight/statistics',
        queryParameters: params.isNotEmpty ? params : null,
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (data) => WeightStatistic.fromJson(data),
      );

      if (!apiResponse.success) {
        throw ApiException(apiResponse.message);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<WeightStatistic> getMonthlyWeightStatistics({
    required int sheepId,
    int? year,
  }) async {
    try {
      final params = <String, dynamic>{};
      if (year != null) {
        params['year'] = year;
      }

      final response = await _dio.get(
        '/sheep-weight/$sheepId/statistics',
        queryParameters: params.isNotEmpty ? params : null,
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (data) => WeightStatistic.fromJson(data),
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
