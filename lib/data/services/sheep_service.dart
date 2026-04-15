import 'package:dio/dio.dart';
import 'package:gosheep_mobile/data/api_client.dart';
import '../models/sheep_response.dart';

class SheepService {
  final Dio _dio = ApiClient.dio;

  Future<SheepResponse> getSheep({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/sheep',
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );

      return SheepResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    final message =
        e.response?.data?['message'] ??
            e.message ??
            'Terjadi kesalahan';

    return Exception(message);
  }
}