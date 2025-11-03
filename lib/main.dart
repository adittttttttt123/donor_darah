import 'package:flutter/material.dart';
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
      theme: ThemeData(
        fontFamily: 'Courier', // mirip monospace
        scaffoldBackgroundColor: const Color(0xFFE0E0E0),
      ),
      debugShowCheckedModeBanner: false,
      home: const UserLoginScreen(),
      routes: {
        '/dashboard': (context) => const UserDashboardScreen(),
        '/jadwal': (context) => const UserJadwalScreen(),
        '/riwayat': (context) => const UserRiwayatScreen(),
        '/profil': (context) => const UserProfilScreen(),
      },
    );
  }
}
