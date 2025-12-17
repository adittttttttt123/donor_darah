import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/app_theme.dart';
import 'screens/user/user_login.dart';
import 'screens/user/user_register.dart';
import 'screens/user/user_dashboard.dart';
import 'screens/user/user_jadwal.dart';
import 'screens/user/user_riwayat.dart';
import 'screens/user/user_profil.dart';
import 'screens/settings/settings_page.dart';
import 'screens/user/user_daftar_donor.dart';
import 'screens/admin/login_admin_page.dart';
import 'screens/admin/dashboard_admin_page.dart';
import 'screens/admin/data_pendonor_page.dart';
import 'screens/admin/stok_darah_page.dart';
import 'screens/admin/jadwal_donor_page.dart';
import 'screens/admin/form_jadwal_page.dart';
import 'screens/admin/detail_pendonor_page.dart';

import 'controllers/data_controller.dart';
import 'controllers/user_controller.dart';

void main() {
  Get.put(UserController()); // Existing user controller
  Get.put(DataController()); // New global data controller
  runApp(const DonorDarahUserApp());
}

class DonorDarahUserApp extends StatelessWidget {
  const DonorDarahUserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DonorDarahApp User',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/user_register',
      routes: {
        '/user_register': (context) => const UserRegisterScreen(),
        '/': (context) => const UserLoginScreen(),
        '/dashboard': (context) => const UserDashboardScreen(),
        '/jadwal': (context) => const UserJadwalScreen(),
        '/riwayat': (context) => const UserRiwayatScreen(),
        '/profil': (context) => const UserProfilScreen(),
        '/settings': (context) => const SettingsPage(),
        '/daftar_donor': (context) => const UserDaftarDonorScreen(),
        '/admin_login': (context) => const LoginAdminPage(),
        '/admin/dashboard': (context) => const DashboardAdminPage(),
        '/admin/pendonor': (context) => const DataPendonorPage(),
        '/admin/stok': (context) => const StokDarahPage(),

        '/admin/jadwal': (context) => const JadwalDonorPage(),
        '/admin/jadwal_form': (context) => const FormJadwalPage(),
        '/admin/pendonor_detail': (context) => const DetailPendonorPage(),
      },
    );
  }
}
