import 'package:flutter/material.dart';
import 'login_admin_page.dart';
import 'dashboard_admin_page.dart';


void main() {
  runApp(const DonorDarahApp());
}

class DonorDarahApp extends StatelessWidget {
  const DonorDarahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Donor Darah',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginAdminPage(),
        '/dashboard': (context) => const DashboardAdminPage(),
      },
    );
  }
}
