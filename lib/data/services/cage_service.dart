import 'package:dio/dio.dart';
import 'package:gosheep_mobile/data/api_client.dart';
import 'package:gosheep_mobile/data/exceptions/api_exception.dart';
import 'package:gosheep_mobile/data/exceptions/error_handler.dart';
import 'package:gosheep_mobile/data/models/api_response.dart';
import 'package:gosheep_mobile/data/models/cage.dart';

class CageService {
  final Dio _dio = ApiClient.dio;

  Future<List<Cage>> getCages() async {
    try {
      final response = await _dio.get('/cages');

      final apiResponse = ApiResponse<List<Cage>>.fromJson(
        response.data,
        (data) => (data as List).map((e) => Cage.fromJson(e)).toList(),
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
