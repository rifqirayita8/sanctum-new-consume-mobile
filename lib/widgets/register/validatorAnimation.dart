import 'package:flutter/material.dart';
import 'package:sanctum_mobile/util/color.dart';
import 'package:sanctum_mobile/widgets/common/confirm_button.dart';
import 'package:sanctum_mobile/widgets/common/password_provider.dart';

class ValidatorAnimation extends StatefulWidget {
  final VoidCallback? onPressed;
  const ValidatorAnimation({
    super.key, 
    required this.onPressed
    });

  @override
  State<ValidatorAnimation> createState() => _ValidatorAnimationState();
}

class _ValidatorAnimationState extends State<ValidatorAnimation> {
  bool _isAgree= false;
  late TextEditingController _passwordController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _passwordController = PasswordProvider.of(context)!.passwordController;
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_onPasswordChanged);
    super.dispose();
  }

  void _onPasswordChanged(){
    setState(() {
      
    });
  }

  bool _hasMinLength() {
    return _passwordController.text.length >= 8;
  }
  bool _hasNumber() {
    return RegExp(r'[0-9]').hasMatch(_passwordController.text);
  }
  bool _hasUpperLowercase() {
    return RegExp(r'[A-Z]').hasMatch(_passwordController.text) &&
        RegExp(r'[a-z]').hasMatch(_passwordController.text);
  }

  void _onAgreeChanged(bool? value) {
    setState(() {
      _isAgree = value ?? false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: _hasMinLength() ? Colors.green : Colors.grey.shade400,
                border: Border.all(
                  color: Colors.grey.shade400,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Center(
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
            SizedBox(width: 10),
            Text('At least 8 characters'),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: _hasNumber() ? Colors.green : Colors.grey.shade400,
                border: Border.all(
                  color: Colors.grey.shade400,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Center(
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
            SizedBox(width: 10),
            Text('At least 1 number'),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: _hasUpperLowercase() ? Colors.green : Colors.grey.shade400,
                border: Border.all(
                  color: Colors.grey.shade400,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Center(
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text('Both upper and lower case letters'),
          ],
        ),
        const SizedBox(height: 60),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: Transform.scale(
                scale: 1.1,
                child: Checkbox(
                  value: _isAgree, 
                  onChanged: _onAgreeChanged,
                  activeColor: confirmButton,
                  checkColor: primaryHeader,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Flexible(
              child: Text(
                'By agreeing to the terms and conditions, you are entering into a legally binding contract with the service provider',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        ConfirmButton(
          text: 'Register', 
          onPressed: _isAgree ? widget.onPressed : null,
          enabled: _isAgree,
        ),
      ],
    );
  }
}