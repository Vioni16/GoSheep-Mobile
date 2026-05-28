import 'package:dio/dio.dart';
import 'package:gosheep_mobile/data/api_client.dart';
import 'package:gosheep_mobile/data/exceptions/api_exception.dart';
import 'package:gosheep_mobile/data/exceptions/error_handler.dart';
import 'package:gosheep_mobile/data/models/cursor_response.dart';
import 'package:gosheep_mobile/data/models/mating_record.dart';

class MatingRecordService {
  final Dio _dio = ApiClient.dio;

  Future<CursorResponse<MatingRecord>> getMatingRec({
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
        '/mating-records',
        queryParameters: queryParams,
      );

      final result = CursorResponse<MatingRecord>.fromJson(
        response.data,
        (e) => MatingRecord.fromJson(e),
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
