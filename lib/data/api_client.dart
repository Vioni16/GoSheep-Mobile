import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/utils/navigator_key.dart';
import 'package:gosheep_mobile/core/widgets/toast_widget.dart';
import 'package:gosheep_mobile/data/services/secure_storage_service.dart';
import 'package:gosheep_mobile/routes/app_routes.dart';

class ApiClient {
  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: "http://10.213.37.17:8000/api",
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 30),
            headers: {"Accept": "application/json"},
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final token = await SecureStorageService.getToken();

              if (token?.isNotEmpty ?? false) {
                options.headers['Authorization'] = 'Bearer $token';
              }

              handler.next(options);
            },
            onError: (DioException e, handler) async {
              if (e.response?.statusCode == 401) {
                final path = e.requestOptions.path;
                if (path.contains('/login') || path.contains('/auth')) {
                  return handler.reject(e);
                }

                final token = await SecureStorageService.getToken();
                if (token?.isNotEmpty ?? false) {
                  await SecureStorageService.deleteToken();
                }
                _showErrorSnackbar(
                  'Sesi anda telah berakhir, silakan login kembali',
                );
                navigatorKey.currentState?.pushNamedAndRemoveUntil(
                  AppRoutes.login,
                  (route) => false,
                );
              }
              handler.reject(e);
            },
          ),
        )
        ..interceptors.add(
          LogInterceptor(requestBody: true, responseBody: true),
        );

  static void _showErrorSnackbar(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlay = navigatorKey.currentState?.overlay;
      if (overlay != null) {
        ToastService.showWithOverlay(overlay, message);
      }
    });
  }
}
