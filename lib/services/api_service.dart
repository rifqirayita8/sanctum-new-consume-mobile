import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.baseUrl = 'https://sanctum-new-production.up.railway.app/api';
  }

  Future<Response> login(String email, String password) async {
    try {
      final Response response = await _dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return response;
    } catch (e) {
      print('Error Logging User: $e');
      throw e;
    }
  }

  static Future<void> logout(String token) async {
    try {
      Response response = await _dio.post('/logout',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));

      if (response.statusCode == 200) {
        print('Logout Success');
      } else {
        print('Logout Failed');
      }
    } catch (e) {
      print('Error Logging User: $e');
      throw e;
    }
  }
}
