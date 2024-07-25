import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.baseUrl = 'https://sanctum-new-production.up.railway.app/api';
    _dio.options.receiveTimeout = const Duration(milliseconds: 20000);
    _dio.options.connectTimeout = const Duration(milliseconds: 20000);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      Response response = await _dio.post(
        '/login',
        data: FormData.fromMap({
          'email': email, 
          'password': password
          }
        ),
        options: Options(
          headers: {
          'Accept': 'application/json',
          },
          sendTimeout: const Duration(milliseconds: 10000),
          receiveTimeout: const Duration(milliseconds: 10000),
        )
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        return {'status': true, 'token': response.data['token']};
      } else {
        return {'status': false, 'message': response.data['message']};
      }
    } on DioException catch (e, trace) {
      if (e.response != null) {
        print('Error response status: ${e.response?.statusCode}');
        print('Error response data: ${e.response?.data}');
      } else {
        print('Error sending request: $e');
      }
      return {'status': false, 'message': 'Error sending request: $e, trace: $trace'};
    }
  }

  Future<void> logout(String token) async {
    try {
      await _dio.get(
        '/logout',
          options: Options(
            headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
            },
            sendTimeout: const Duration(milliseconds: 10000),
            receiveTimeout: const Duration(milliseconds: 10000),
          ),
        );
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error response status: ${e.response?.statusCode}');
        print('Error response data: ${e.response?.data}');
      } else {
        print('Error sending request: $e');
      }
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      Response response= await _dio.post(
        '/register',
        data: FormData.fromMap({
          'name': name,
          'email': email,
          'password': password,
        }),
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
          sendTimeout: const Duration(milliseconds: 10000),
          receiveTimeout: const Duration(milliseconds: 10000),
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        return {'status': true, 'message': response.data['message']};
      } else {
        return {'status': false, 'message': response.data['message']};
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error response status: ${e.response?.statusCode}');
        print('Error response data: ${e.response?.data}');
      } else {
        print('Error sending request : $e');
      }
      return {'status': false, 'message': 'Error sending request: $e'};
    }
  }

  Future<String> fetchUserName() async  {
    try {
      final sharedPreferences= await SharedPreferences.getInstance();
      final token = sharedPreferences.getString('token');

      if (token == null) {
        print('Token not found');
      }

      Response response = await _dio.get(
        '/showCurrent',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['name'];
      } else {
        throw Exception('Failed to load user name');
      }

    } on DioException catch (e) {
      print(e);
      return 'User';
    }
  }
}
