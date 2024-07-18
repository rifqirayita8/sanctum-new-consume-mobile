import 'package:flutter/material.dart';
import 'package:sanctum_mobile/services/api_service.dart';
import 'package:sanctum_mobile/services/shared_preferences.dart';

class Homepage extends StatelessWidget {
  // final String authToken;

  const Homepage({
    super.key,
  });

  void _logout(BuildContext context) async {
    var sharedPreferences =
        SharedPreferencesProvider.of(context)?.sharedPreferences;
    if (sharedPreferences != null) {
      String? token = sharedPreferences.getString('token');
      if (token != null) {
        final apiService = ApiService();
        await apiService.logout(token);
        await sharedPreferences.remove('token');
        Navigator.of(context).pushReplacementNamed('/login');
      } else {
        print('No token found in SharedPref');
      }
    } else {
      print('SharedPref instance is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "HomePage",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Text(
            "PENCET DIBAWAH INI",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.red),
            onPressed: () {
              _logout(context);
            },
            child: const Text("Logout"),
          )
        ],
      ),
    );
  }
}
