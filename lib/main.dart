import 'package:flutter/material.dart';
import 'package:sanctum_mobile/pages/homepage.dart';
import 'package:sanctum_mobile/pages/login_page.dart';
import 'package:sanctum_mobile/routes/routes.dart';
import 'package:sanctum_mobile/services/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MainApp(sharedPreferences: sharedPreferences));
}

class MainApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  const MainApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return SharedPreferencesProvider(
      sharedPreferences: sharedPreferences,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: LoginPage(),
        initialRoute: Routes.login,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
