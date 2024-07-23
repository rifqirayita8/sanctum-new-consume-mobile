import 'package:flutter/material.dart';

class PasswordProvider extends InheritedWidget {
  final TextEditingController passwordController;

  const PasswordProvider({
    super.key,
    required this.passwordController,
    required super.child,
  });

  static PasswordProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PasswordProvider>();
  }

  @override
  bool updateShouldNotify(PasswordProvider old) {
    return passwordController != old.passwordController;
  }
}
