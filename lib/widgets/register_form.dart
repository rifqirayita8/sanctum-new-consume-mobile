import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanctum_mobile/blocs/auth/auth_bloc.dart';
import 'package:sanctum_mobile/blocs/auth/auth_event.dart';
import 'package:sanctum_mobile/blocs/auth/auth_state.dart';
import 'package:sanctum_mobile/util/color.dart';
import 'package:sanctum_mobile/widgets/common/custom_form.dart';
import 'package:sanctum_mobile/widgets/common/password_provider.dart';
import 'package:sanctum_mobile/widgets/common/snackbar_custom.dart';
import 'package:sanctum_mobile/widgets/register/validatorAnimation.dart';

class RegisterForm extends StatefulWidget {

  const RegisterForm({
    super.key, 
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController= TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.of(context).pushReplacementNamed('/login');
          ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            CustomSnackbar.create(
              'Registration successful! Please login to continue', 
              primaryHeader
            ),
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            CustomSnackbar.create(state.message, danger)
          );
        }
      },
      child: SingleChildScrollView(
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
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.5),
                        child: CustomFormField(
                          controller: _passwordController, 
                          prefixIcon: const Icon(Icons.lock_outline_rounded), 
                          suffixIcon: const Icon(Icons.visibility_off),
                          hintText: 'Enter your password',
                          isPassword: true,
                        ),
                      ),
                      CustomFormField(
                        controller: _confirmPasswordController, 
                        prefixIcon: const Icon(Icons.lock_outline_rounded), 
                        suffixIcon: const Icon(Icons.visibility_off),
                        hintText: 'Confirm your password',
                        isPassword: true,
                      ),
                    ],
                  )
                ),
                const SizedBox(height: 20),
                ValidatorAnimation(
                  onPressed: () {
                    final name= _namecontroller.text;
                    final email= _emailController.text;
                    final password= _passwordController.text;
                    final confirmPassword= _confirmPasswordController.text;

                    if (confirmPassword != password) {
                      ScaffoldMessenger.of(context)
                      ..clearSnackBars()
                      ..showSnackBar(
                        CustomSnackbar.create('Passwords do not match', danger)
                      );
                      return;                    
                    } else {
                      context.read<AuthBloc>().add(RegisterEvent(
                        name: name, email: email, password: password
                        )
                      );
                    }                    
                  },
                ),
              ],
            )
          ),
        ),
      )
    );
  }
}