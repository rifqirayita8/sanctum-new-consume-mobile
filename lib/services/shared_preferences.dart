import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider extends InheritedWidget {
  final SharedPreferences sharedPreferences;

  const SharedPreferencesProvider({
    super.key,
    required this.sharedPreferences,
    required super.child,
  });

  static SharedPreferencesProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SharedPreferencesProvider>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
