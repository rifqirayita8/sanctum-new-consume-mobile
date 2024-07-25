import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sanctum_mobile/services/api_service.dart';
import 'package:sanctum_mobile/util/color.dart';
import 'package:sanctum_mobile/widgets/common/custom_form.dart';
import 'package:sanctum_mobile/widgets/common/password_provider.dart';
import 'package:sanctum_mobile/widgets/register/validatorAnimation.dart';

class RegisterForm extends StatefulWidget {
  final ApiService apiService;
  final ValueNotifier<bool> isLoading;

  const RegisterForm({
    super.key, 
    required this.apiService, 
    required this.isLoading
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController= TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final _formKey= GlobalKey<FormState>();

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters';
    } else if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    } else if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    return null;
  }

   String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password confirmation';
    } else if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  registerUser() async {
    widget.isLoading.value = true;
    print('Name: ${_namecontroller.text}');
    print('email: ${_emailController.text}');
    print('Password: ${_passwordController.text}');

    if(_formKey.currentState?.validate() ?? false) {
      try {
        var result= await widget.apiService.register(
          _namecontroller.text, 
          _emailController.text, 
          _passwordController.text
        );
        Navigator.of(context).pushReplacementNamed('/login');
        print(result);

      } on DioException catch (e) {
        print('Error during registration: $e');
      } finally {
        widget.isLoading.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: PasswordProvider(
        passwordController: _passwordController,
        child: Container(
          padding: const EdgeInsets.all(20),  
          color: primaryBody,
          child: 
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 12.5),
                        child: CustomFormField(
                          controller: _namecontroller, 
                          prefixIcon: const Icon(Icons.person_outline_rounded), 
                          hintText: 'Your Name',
                        ),
                      ),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.5),
                      child: CustomFormField(
                        controller: _passwordController, 
                        prefixIcon: const Icon(Icons.lock_outline_rounded), 
                        suffixIcon: const Icon(Icons.visibility_off),
                        hintText: 'Enter your password',
                        isPassword: true,
                        validator: passwordValidator,
                      ),
                    ),
                    CustomFormField(
                      controller: _confirmPasswordController, 
                      prefixIcon: const Icon(Icons.lock_outline_rounded), 
                      suffixIcon: const Icon(Icons.visibility_off),
                      hintText: 'Confirm your password',
                      isPassword: true,
                      validator: confirmPasswordValidator,
                    ),
                  ],
                )
              ),
              const SizedBox(height: 20),
              ValidatorAnimation(onPressed: registerUser,),
            ],
          )
        ),
      ),
    );
  }
}