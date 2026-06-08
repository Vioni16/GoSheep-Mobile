import 'package:dio/dio.dart';
import 'package:gosheep_mobile/data/api_client.dart';
import 'package:gosheep_mobile/data/exceptions/api_exception.dart';
import 'package:gosheep_mobile/data/exceptions/error_handler.dart';
import 'package:gosheep_mobile/data/models/cursor_response.dart';
import 'package:gosheep_mobile/data/models/mating_record.dart';
import 'package:gosheep_mobile/data/models/mating_partner.dart';

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

  Future<MatingRecord> getMatingRecordById(int id) async {
    try {
      final response = await _dio.get('/mating-records/$id');
      final data = response.data;
      if (data['success'] != true) {
        throw ApiException(data['message'] ?? 'Gagal mengambil data perkawinan');
      }
      return MatingRecord.fromJson(data['data']);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<MatingPartner>> getMatingPartners(int sheepId) async {
    try {
      final response = await _dio.get('/mating-records/partners/$sheepId');
      final data = response.data;
      if (data['success'] != true) {
        throw ApiException(data['message'] ?? 'Gagal mengambil data pasangan');
      }
      return (data['data'] as List)
          .map((e) => MatingPartner.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
