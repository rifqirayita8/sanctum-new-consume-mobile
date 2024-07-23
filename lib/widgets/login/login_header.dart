import 'package:flutter/material.dart';
import 'package:sanctum_mobile/util/color.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: 
      [
        Row(
          mainAxisAlignment: MainAxisAlignment.center ,
          children: [
            Image.asset('assets/images/medical-logo.png', width: 50, height: 50),
            const Text(
              'e-Klinik', style: TextStyle(
                fontSize: 28, 
                color: primaryHeader, 
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
        const Text('Welcome to e-Klinik', 
        style: TextStyle(
          fontSize: 28, 
          fontWeight: FontWeight.w600,
          )
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 105.0),
          child: Text(
            textAlign: TextAlign.center,
            'Sign in or register below to access to our features', 
            style: TextStyle(
              fontSize: 16, color: shadesGrey
              ),
            ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}