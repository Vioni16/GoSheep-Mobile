import 'package:dio/dio.dart';
import 'package:gosheep_mobile/data/api_client.dart';
import 'package:gosheep_mobile/data/exceptions/api_exception.dart';
import 'package:gosheep_mobile/data/exceptions/error_handler.dart';
import 'package:gosheep_mobile/data/models/api_response.dart';
import 'package:gosheep_mobile/data/models/farm_report.dart';

class ReportService {
  final Dio _dio = ApiClient.dio;

  Future<ApiResponse<FarmReport>> getFarmReport() async {
    try {
      final response = await _dio.get('/reports/farm');

      final apiResponse = ApiResponse<FarmReport>.fromJson(
        response.data,
        (data) => FarmReport.fromJson(data),
      );

      if (!apiResponse.success) {
        throw ApiException(apiResponse.message);
      }

      return apiResponse;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}