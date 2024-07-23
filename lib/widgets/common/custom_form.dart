import 'package:flutter/material.dart';
import 'package:sanctum_mobile/util/color.dart';

class CustomFormField extends StatefulWidget {
  final TextEditingController controller;
  final Widget prefixIcon;
  final String hintText;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool isPassword;

  const CustomFormField({
    super.key, 
    required this.controller, 
    required this.prefixIcon, 
    required this.hintText, 
    this.validator, 
    this.suffixIcon, 
    this.keyboardType,
    this.isPassword= false,
    });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      elevation: 0,
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _isObscure : false,
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.isPassword ?  
          IconButton(
            icon: Icon(
              _isObscure ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
          ) : widget.suffixIcon,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: shadesGrey,
            fontSize: 16,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        keyboardType: widget.keyboardType,
        validator: widget.validator,
      ),
    );
  }
}