import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sanctum_mobile/services/api_service.dart';
import 'package:sanctum_mobile/services/shared_preferences.dart';
import 'package:sanctum_mobile/widgets/common/loading_indicator.dart';

class Homepage extends StatefulWidget {

  const Homepage({
    super.key,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  void _logout(BuildContext context) async {
  _isLoading.value = true;
  try {
    var sharedPreferences =
        SharedPreferencesProvider.of(context)?.sharedPreferences;
    if (sharedPreferences != null) {
      String? token = sharedPreferences.getString('token');
      if (token != null) {
        final apiService = ApiService();
        await apiService.logout(token);
        await sharedPreferences.remove('token');
        Navigator.of(context).pushReplacementNamed('/login');
        print('Berhasil Logout');
      } else {
        print('No token found in SharedPref');
      }
    } else {
      print('SharedPref instance is null');
    }
  } on DioException catch (e) {
    print('Error during logout: $e');
  } finally {
    _isLoading.value = false;
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
      body: Stack(
        children: [
          Column(
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
          ValueListenableBuilder<bool>(
            valueListenable: _isLoading, 
            builder: (context, isLoading, child){
              return isLoading ? const LoadingIndicator() : const SizedBox.shrink();
            }
          ),
        ],
      ),
    );
  }
}
