import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sanctum_mobile/services/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var sharedPreferences =
          SharedPreferencesProvider.of(context)?.sharedPreferences;
      var token = sharedPreferences?.getString('token');
      if (token != null) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  loginUser() async {
    print('Email: ${_emailController.text}');
    print('Password: ${_passwordController.text}');

    Dio dio = Dio();

    dio.options.receiveTimeout = const Duration(milliseconds: 20000);
    dio.options.connectTimeout = const Duration(milliseconds: 20000);

    try {
      Response response = await dio.post(
        'https://sanctum-new-production.up.railway.app/api/login',
        data: FormData.fromMap({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200 && response.data['status'] == true) {
        var sharedPreferences =
            SharedPreferencesProvider.of(context)?.sharedPreferences;
        if (sharedPreferences != null) {
          await sharedPreferences.setString('token', response.data['token']);
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } else {
        print('Shared Preferences Instance is null');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error response status: ${e.response?.statusCode}');
        print('Error response data: ${e.response?.data}');
      } else {
        print('Error sending request: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                loginUser();
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
