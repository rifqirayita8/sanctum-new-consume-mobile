import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sanctum_mobile/services/api_service.dart';
import 'package:sanctum_mobile/services/shared_preferences.dart';
import 'package:sanctum_mobile/util/color.dart';
import 'package:sanctum_mobile/widgets/common/get_current_user.dart';
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
        leading: Transform.translate(
          offset: const Offset(10, 0),
          child: Image.asset(
            'assets/images/medical-logo.png',
            width: 40,
            height: 40,
          ),
        ),
        title: Row(
          children: [
            const Text(
              "e-Klinik",
              style: TextStyle(
                fontSize: 24,
                color: primaryHeader,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 170,
            ),
            IconButton(
              onPressed: () {}, 
              icon: const Icon(
                Icons.calendar_today_rounded,
                size: 25,
              ),
            ),
            IconButton(
              onPressed: () {}, 
              icon: const Icon(
                Icons.notifications_none_rounded,
                size: 30,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const GetCurrentUser(),
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
            ),
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
