import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sanctum_mobile/services/api_service.dart';
import 'package:sanctum_mobile/services/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService apiService = ApiService();

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

    var result =
        await apiService.login(_emailController.text, _passwordController.text);

    if (result['status']) {
      var sharedPreferences =
          SharedPreferencesProvider.of(context)?.sharedPreferences;
      if (sharedPreferences != null) {
        await sharedPreferences.setString('token', result['token']);
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } else {
      print('Login failed: ${result['message']}');
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
