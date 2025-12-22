import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/app_theme.dart';

// USER
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

// ADMIN
import 'screens/admin/login_admin_page.dart';
import 'screens/admin/dashboard_admin_page.dart';
import 'screens/admin/data_pendonor_page.dart';
import 'screens/admin/stok_darah_page.dart';
import 'screens/admin/jadwal_donor_page.dart';
import 'screens/admin/form_jadwal_page.dart';
import 'screens/admin/detail_pendonor_page.dart';

// CONTROLLER
import 'controllers/user_controller.dart';
import 'controllers/theme_controller.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // Initialize Storage

  try {
    await Supabase.initialize(
      url: 'https://iwnlmogzfjeqxdbhutsd.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml3bmxtb2d6ZmplcXhkYmh1dHNkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU5NTI2NTcsImV4cCI6MjA4MTUyODY1N30.5BHeuEbDeKToPBJkKp5a-oSZmnymBjiIgAN9qW4uiBo',
    );
  } catch (e) {
    debugPrint("Supabase init failed: $e");
  }

  Get.put(UserController());
  final themeController = Get.put(ThemeController()); // Put ThemeController

  runApp(DonorDarahUserApp(themeController: themeController));
}

class DonorDarahUserApp extends StatelessWidget {
  final ThemeController themeController;
  const DonorDarahUserApp({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Donor Darah',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme, // Add Dark Theme
      themeMode: themeController.themeMode, // Use Controller Mode
      initialRoute: '/',
      routes: {
        '/': (context) => const UserLoginScreen(),
        '/user_register': (context) => const UserRegisterScreen(),
        '/dashboard': (context) => const UserDashboardScreen(),
        '/jadwal': (context) => const UserJadwalScreen(),
        '/riwayat': (context) => const UserRiwayatScreen(),
        '/profil': (context) => const UserProfilScreen(),
        '/settings': (context) => const SettingsPage(),
        '/daftar_donor': (context) => const UserDaftarDonorScreen(),
        '/kartu_donor': (context) => const UserKartuDonorScreen(),
        '/lokasi_unit': (context) => const UserLokasiUnitScreen(),
        '/daftar_sukses': (context) => const UserDaftarSuksesScreen(),

        // ADMIN
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
