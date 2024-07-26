import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanctum_mobile/blocs/auth/auth_bloc.dart';
import 'package:sanctum_mobile/blocs/auth/auth_event.dart';
import 'package:sanctum_mobile/blocs/auth/auth_state.dart';
import 'package:sanctum_mobile/services/shared_preferences.dart';
import 'package:sanctum_mobile/util/color.dart';
import 'package:sanctum_mobile/widgets/common/confirm_button.dart';
import 'package:sanctum_mobile/widgets/common/custom_form.dart';
import 'package:sanctum_mobile/widgets/common/snackbar_custom.dart';
import 'package:sanctum_mobile/widgets/login/login_with_options.dart';
import 'package:sanctum_mobile/widgets/login/terms_policy.dart';

class LoginForm extends StatefulWidget {

  const LoginForm({
    super.key, 
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          var sharedPreferences = SharedPreferencesProvider.of(context)?.sharedPreferences;
          if (sharedPreferences != null) {
            sharedPreferences.setString('token', state.token);
            Navigator.of(context).pushReplacementNamed('/home');
          }
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(CustomSnackbar.create(state.message, danger)
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        color: primaryBody,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 30.0, bottom: 10),
                child: LoginWith(
                  label: 'Login with Apple',
                  urlImage: 'assets/images/apple-logo.png',
                ),
              ),
              LoginWith(
                label: 'Login with Google',
                urlImage: 'assets/images/google-logo.png',
                onPressed: () {
                },
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
                    ),
                    const SizedBox(height: 10),
                    CustomFormField(
                      controller: _passwordController, 
                      prefixIcon: const Icon(Icons.lock_outline_rounded), 
                      suffixIcon: const Icon(Icons.visibility_off),
                      hintText: 'Enter your password',
                      isPassword: true,
                    ),
                  ],
                )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 55),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        print('forogt paswor');
                      },
                      child: const Text(
                        textAlign: TextAlign.start,
                        'Forgot Password?',
                        style: TextStyle(
                          fontWeight: FontWeight.w500
                        ),
                      )
                    ),
                  ],
                ),
              ),
              ConfirmButton(
                text: 'Login', 
                onPressed: () {
                  final email = _emailController.text;
                  final password = _passwordController.text;
                  context.read<AuthBloc>().add(
                      LoginEvent(
                        email: email, password: password
                        )
                      ); 
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
      ),
    );
  }
}
