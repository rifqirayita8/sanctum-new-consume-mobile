import 'package:flutter/material.dart';
import 'package:sanctum_mobile/services/api_service.dart';
import 'package:sanctum_mobile/util/color.dart';
import 'package:sanctum_mobile/widgets/common/loading_indicator.dart';

class GetCurrentUser extends StatelessWidget {
  const GetCurrentUser({super.key});

  String greetUser() {
  final currentTime = DateTime.now();
  final hour = currentTime.hour;
  if (hour < 12) {
    return 'Morning';
  } else if (hour < 18) {
    return 'Afternoon';
  } else {
    return 'Evening';
  }
}

  @override
  Widget build(BuildContext context) {
    final ApiService apiService= ApiService();

    return FutureBuilder<String>(
      future: apiService.fetchUserName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading name'));
        } else if (snapshot.hasData) {
          final userName= snapshot.data ?? 'User';
          final greeting= greetUser();
          return Column(
            children: [
              Text(
                'Good $greeting, $userName',
                style: const TextStyle(
                  fontSize: 20,
                  color: shadesGrey,
                )
              ),
              const SizedBox(height: 10),
              const Text(
                'Keep it going!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600
                ),
              )
            ],
          );
        } else {
          return const Center(child: Text('No data'));
        }
      }
    );
  }
}