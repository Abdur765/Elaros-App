import 'package:flutter/material.dart';
import 'views/notifications_screen.dart';
import 'views/alert_preferences_screen.dart';
import 'views/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // FIRST SCREEN
      home: const NotificationsScreen(),

      routes: {
        '/notifications': (context) => const NotificationsScreen(),
        '/preferences': (context) => const AlertPreferencesScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
