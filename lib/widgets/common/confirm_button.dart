import 'package:flutter/material.dart';
import 'package:sanctum_mobile/util/color.dart';

class ConfirmButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? outlineColor;
  final void Function()? onPressed;
  final bool enabled;

  const ConfirmButton({
    super.key, 
    required this.text, 
    this.backgroundColor, 
    this.textColor, 
    required this.onPressed, 
    this.outlineColor, 
    this.enabled= true,
    });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed!();
      },
      child: Container(
        decoration: BoxDecoration(
          color: enabled ? (backgroundColor ?? confirmButton) : Colors.grey,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: enabled ? (outlineColor ?? outlineConfirmButton) : Colors.grey,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Center(
          child: Text(
            text, 
              style: TextStyle(
                color: enabled ? (textColor ?? primaryHeader) : Colors.black38 ,
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
        ),
      ),
    );
  }
}