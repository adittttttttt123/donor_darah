import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/app_theme.dart';
import 'screens/user/user_login.dart';
import 'screens/user/user_register.dart';
import 'screens/user/user_dashboard.dart';
import 'screens/user/user_jadwal.dart';
import 'screens/user/user_riwayat.dart';
import 'screens/user/user_profil.dart';
import 'screens/settings/settings_page.dart';
import 'screens/user/user_daftar_donor.dart';
import 'screens/user/user_kartu_donor.dart';

import 'screens/user/user_lokasi_unit.dart';
import 'screens/user/user_daftar_sukses.dart';
import 'screens/admin/login_admin_page.dart';
import 'screens/admin/dashboard_admin_page.dart';
import 'screens/admin/data_pendonor_page.dart';
import 'screens/admin/stok_darah_page.dart';
import 'screens/admin/jadwal_donor_page.dart';
import 'screens/admin/form_jadwal_page.dart';
import 'screens/admin/detail_pendonor_page.dart';

import 'controllers/data_controller.dart';
import 'controllers/user_controller.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() async {
  setUrlStrategy(PathUrlStrategy());
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );

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
        '/kartu_donor': (context) => const UserKartuDonorScreen(),
        '/lokasi_unit': (context) => const UserLokasiUnitScreen(),
        '/daftar_sukses': (context) => const UserDaftarSuksesScreen(),
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
