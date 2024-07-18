import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.baseUrl = 'https://sanctum-new-production.up.railway.app/api';
    _dio.options.receiveTimeout = const Duration(milliseconds: 20000);
    _dio.options.connectTimeout = const Duration(milliseconds: 20000);
  }

  Future<void> logout(String token) async {
    try {
      await _dio.get('/logout',
          options: Options(headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          }));
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error response status: ${e.response?.statusCode}');
        print('Error response data: ${e.response?.data}');
      } else {
        print('Error sending request: $e');
      }
    }
  }
}
