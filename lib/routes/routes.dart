import 'package:flutter/material.dart';
import 'package:sanctum_mobile/pages/homepage.dart';
import 'package:sanctum_mobile/pages/login_page.dart';

class Routes {
  static const String login = '/login';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const LoginPage());

      case Routes.home:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const Homepage());

      default:
        return _errorRoute(settings);
    }
  }

  static MaterialPageRoute _errorRoute(RouteSettings settings) {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              body: Center(
                child: Text('No route defined for ${settings.name}'),
              ),
            ));
  }
}
