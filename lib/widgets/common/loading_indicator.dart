import 'package:flutter/material.dart';
import 'package:sanctum_mobile/util/color.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.black.withOpacity(0.3),
        child: const CircularProgressIndicator(
          backgroundColor: confirmButton,
          color: primaryHeader,
        ),
      ),
    );
  }
}