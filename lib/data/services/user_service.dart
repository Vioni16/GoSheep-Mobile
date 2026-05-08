import 'package:dio/dio.dart';
import 'package:gosheep_mobile/data/api_client.dart';
import 'package:gosheep_mobile/data/exceptions/api_exception.dart';
import 'package:gosheep_mobile/data/exceptions/error_handler.dart';
import 'package:gosheep_mobile/data/models/api_response.dart';
import 'package:gosheep_mobile/data/models/login_response.dart';
import 'package:gosheep_mobile/data/services/secure_storage_service.dart';

class UserService {
  final Dio _dio = ApiClient.dio;

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      final ApiResponse<LoginResponse> apiResponse = ApiResponse.fromJson(
        response.data,
        (data) => LoginResponse.fromJson(data),
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException(apiResponse.message);
      }

      await SecureStorageService.saveToken(apiResponse.data!.token);

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
