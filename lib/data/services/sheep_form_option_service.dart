import 'package:dio/dio.dart';
import 'package:gosheep_mobile/data/api_client.dart';
import 'package:gosheep_mobile/data/exceptions/api_exception.dart';
import 'package:gosheep_mobile/data/exceptions/error_handler.dart';
import 'package:gosheep_mobile/data/models/api_response.dart';
import 'package:gosheep_mobile/data/models/sheep_option.dart';
import 'package:gosheep_mobile/data/models/cage_option.dart';
import 'package:gosheep_mobile/data/models/cursor_response.dart';

class SheepFormOptionService {
  final Dio _dio = ApiClient.dio;

  Future<List<SheepOption>> getBreedOptions() async {
    try {
      final response = await _dio.get('/sheep-form/breeds');

      final result = ApiResponse<List<SheepOption>>.fromJson(
        response.data,
        (data) =>
            (data as List).map((e) => SheepOption.fromBreedJson(e)).toList(),
      );

      if (!result.success) {
        throw ApiException(result.message);
      }

      return result.data!;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<CageOption>> getCageOptions() async {
    try {
      final response = await _dio.get('/sheep-form/cages');

      final result = ApiResponse<List<CageOption>>.fromJson(
        response.data,
        (data) => (data as List).map((e) => CageOption.fromJson(e)).toList(),
      );

      if (!result.success) {
        throw ApiException(result.message);
      }

      return result.data!;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<CursorResponse<SheepOption>> getSireOptions({
    int? lastId,
    int limit = 5,
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
        '/sheep-form/sires',
        queryParameters: queryParams,
      );

      final result = CursorResponse<SheepOption>.fromJson(
        response.data,
        (e) => SheepOption.fromSireDamJson(e),
      );

      if (!result.success) {
        throw ApiException(result.message);
      }

      return result;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<CursorResponse<SheepOption>> getDamOptions({
    int? lastId,
    int limit = 5,
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
        '/sheep-form/dams',
        queryParameters: queryParams,
      );

      final result = CursorResponse<SheepOption>.fromJson(
        response.data,
        (e) => SheepOption.fromSireDamJson(e),
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
