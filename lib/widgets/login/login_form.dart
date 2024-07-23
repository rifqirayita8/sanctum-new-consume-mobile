import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sanctum_mobile/services/api_service.dart';
import 'package:sanctum_mobile/services/shared_preferences.dart';
import 'package:sanctum_mobile/util/color.dart';
import 'package:sanctum_mobile/widgets/common/confirm_button.dart';
import 'package:sanctum_mobile/widgets/common/custom_form.dart';
import 'package:sanctum_mobile/widgets/common/loading_indicator.dart';
import 'package:sanctum_mobile/widgets/login/login_with_options.dart';
import 'package:sanctum_mobile/widgets/login/terms_policy.dart';

class LoginForm extends StatefulWidget {
  final ApiService apiService;
  final ValueNotifier<bool> isLoading;

  const LoginForm({
    super.key, 
    required this.apiService, 
    required this.isLoading
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  loginUser() async {
    widget.isLoading.value = true;
    print('Email: ${_emailController.text}');
    print('Password: ${_passwordController.text}');

    try {
      var result = await widget.apiService.login(
          _emailController.text, 
          _passwordController.text
          );
      print(result);

      if (result['status']) {
        var sharedPreferences =
            SharedPreferencesProvider.of(context)?.sharedPreferences;
        if (sharedPreferences != null) {
          await sharedPreferences.setString('token', result['token']);
          Navigator.of(context).pushReplacementNamed('/home');
          print(result['token']);
        }
      } else {
        print('Login failed: ${result['message']}');
      }
    } on DioException catch (e) {
      print('Error during login: $e');
    } finally {
      widget.isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: primaryBody,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 10),
              child: LoginWith(
                label: 'Login with Apple',
                urlImage: 'assets/images/apple-logo.png',
              ),
            ),
            const LoginWith(
              label: 'Login with Google',
              urlImage: 'assets/images/google-logo.png',
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30.0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      endIndent: 10,
                    )
                  ),
                  Text('or continue with email', style: TextStyle(
                    color: shadesGrey),
                  ),
                  Expanded(
                    child: Divider(
                      indent: 10,
                    )
                  ),
                ],
              ),
            ),  
            Form(
              child: Column(
                children: [
                  CustomFormField(
                    controller: _emailController, 
                    prefixIcon: const Icon(Icons.email_outlined), 
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } 
                      const emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                      final RegExp emailExp = RegExp(emailRegex);
                      if (!emailExp.hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomFormField(
                    controller: _passwordController, 
                    prefixIcon: const Icon(Icons.lock_outline_rounded), 
                    suffixIcon: const Icon(Icons.visibility_off),
                    hintText: 'Enter your password',
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 8){
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                ],
              )
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 35),
              child: GestureDetector(
                onTap: () {},
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontWeight: FontWeight.w500
                  ),
                )
              ),
            ),
            ConfirmButton(
              text: 'Login', 
              onPressed: () {
                loginUser();
              },
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: PrivacyPolicy(),
            ),
          ],
        ),
      ),
    );
  }
}
