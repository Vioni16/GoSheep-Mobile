import 'package:dio/dio.dart';
import 'package:gosheep_mobile/data/api_client.dart';
import 'package:gosheep_mobile/data/exceptions/error_handler.dart';
import 'package:gosheep_mobile/data/exceptions/api_exception.dart';
import 'package:gosheep_mobile/data/models/cursor_response.dart';
import 'package:gosheep_mobile/data/models/sheep_health_overview.dart';

class HealthRecordService {
  final Dio _dio = ApiClient.dio;

  Future<CursorResponse<SheepHealthOverview>> getHealthRecords({
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
}
