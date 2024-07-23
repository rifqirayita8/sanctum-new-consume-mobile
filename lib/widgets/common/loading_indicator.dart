import 'package:flutter/material.dart';
import 'package:sanctum_mobile/util/color.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: const Center(
        child: CircularProgressIndicator(
          backgroundColor: confirmButton,
        ),
      ),
    );
  }
}