import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sanctum_mobile/util/color.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'By signing up, you agree to our ',
          style: const TextStyle(
            color: shadesGrey,
            fontSize: 14,
            height: 1.5,
          ),
          children: [
            TextSpan(
              text: 'Terms of Service',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: primaryHeader,
                fontSize: 14,
                decoration: TextDecoration.underline,
                height: 1.5,
              ),
              recognizer: TapGestureRecognizer()
              ..onTap = () {
                print('Terms of Service');
              }
            ),
            const TextSpan(
              text: ' and ',
              style: TextStyle(
                color: shadesGrey,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            TextSpan(
              text: 'Privacy Policy',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
                color: primaryHeader,
                fontSize: 14,
                height: 1.5,
              ),
              recognizer: TapGestureRecognizer()
              ..onTap = () {
                print('Privacy Policy');
              },
            )
          ]
        )
      ),
    );
  }
}