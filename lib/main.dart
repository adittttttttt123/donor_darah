import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'screens/user/user_login.dart';
import 'screens/user/user_dashboard.dart';
import 'screens/user/user_jadwal.dart';
import 'screens/user/user_riwayat.dart';
import 'screens/user/user_profil.dart';

void main() {
  runApp(const DonorDarahUserApp());
}

class DonorDarahUserApp extends StatelessWidget {
  const DonorDarahUserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DonorDarahApp User',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const UserLoginScreen(),
        '/dashboard': (context) => const UserDashboardScreen(),
        '/jadwal': (context) => const UserJadwalScreen(),
        '/riwayat': (context) => const UserRiwayatScreen(),
        '/profil': (context) => const UserProfilScreen(),
      },
    );
  }
}
