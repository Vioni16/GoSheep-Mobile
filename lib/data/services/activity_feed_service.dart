import 'package:dio/dio.dart';
import 'package:gosheep_mobile/data/api_client.dart';
import 'package:gosheep_mobile/data/exceptions/error_handler.dart';
import 'package:gosheep_mobile/data/exceptions/api_exception.dart';
import 'package:gosheep_mobile/data/models/cursor_response.dart';
import 'package:gosheep_mobile/data/models/activity_feed.dart';

class ActivityFeedService {
  final Dio _dio = ApiClient.dio;

  Future<CursorResponse<ActivityFeed>> getActivityFeed({
    int? lastId,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{'limit': limit};

      if (lastId != null) {
        queryParams['last_id'] = lastId;
      }

      final response = await _dio.get(
        '/activity-feed',
        queryParameters: queryParams,
      );

      final result = CursorResponse<ActivityFeed>.fromJson(
        response.data,
        (e) => ActivityFeed.fromJson(e),
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
