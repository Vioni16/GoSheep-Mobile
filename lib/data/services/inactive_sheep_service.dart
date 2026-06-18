import 'package:dio/dio.dart';
import 'package:gosheep_mobile/data/api_client.dart';
import 'package:gosheep_mobile/data/exceptions/error_handler.dart';
import 'package:gosheep_mobile/data/exceptions/api_exception.dart';
import 'package:gosheep_mobile/data/models/inactive_sheep.dart';
import 'package:gosheep_mobile/data/models/statistics/inactive_sheep_stats.dart';

class InactiveSheepResponse {
  final List<InactiveSheep> data;
  final bool hasMore;
  final int? nextCursor;

  InactiveSheepResponse({
    required this.data,
    required this.hasMore,
    required this.nextCursor,
  });
}

class InactiveSheepService {
  final Dio _dio = ApiClient.dio;

  Future<InactiveSheepResponse> getInactiveSheep({
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
        '/sheep/inactive',
        queryParameters: queryParams,
      );

      final data = response.data;
      final success = data['success'] ?? false;
      if (!success) {
        throw ApiException(data['message'] ?? 'Gagal mengambil data');
      }

      final rawData = data['data'] as List?;
      final sheepList = rawData != null
          ? rawData.map((e) => InactiveSheep.fromJson(e)).toList()
          : <InactiveSheep>[];

      return InactiveSheepResponse(
        data: sheepList,
        hasMore: data['has_more'] ?? false,
        nextCursor: data['next_cursor'],
      );
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<InactiveSheepStats> getInactiveSheepStats() async {
    try {
      final response = await _dio.get('/sheep/inactive/stats');
      final data = response.data;
      final success = data['success'] ?? false;
      if (!success) {
        throw ApiException(data['message'] ?? 'Gagal mengambil statistik');
      }

      return InactiveSheepStats.fromJson(data['data']);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
