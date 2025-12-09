import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// ADMIN
import 'screens/admin/login_admin_page.dart';
import 'screens/admin/dashboard_admin_page.dart';
import 'screens/admin/data_pendonor_page.dart';
import 'screens/admin/stok_darah_page.dart';
import 'screens/admin/jadwal_donor_page.dart';

// USER
import 'screens/user/user_login.dart';
import 'screens/user/user_dashboard.dart';
import 'screens/user/user_jadwal.dart';
import 'screens/user/user_riwayat.dart';
import 'screens/user/user_profil.dart';

// MIDDLEWARE
import 'utils/role_middleware.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(const DonorDarahApp());
}

class DonorDarahApp extends StatelessWidget {
  const DonorDarahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      getPages: [
        // HALAMAN LOGIN UTAMA
        GetPage(name: '/login', page: () => const UserLoginScreen()),

        // =========================
        //          ADMIN
        // =========================
        GetPage(name: '/admin-login', page: () => const LoginAdminPage()),
        GetPage(
          name: '/admin-dashboard',
          page: () => const DashboardAdminPage(),
          middlewares: [RoleMiddleware('admin')],
        ),
        GetPage(
          name: '/data-pendonor',
          page: () => const DataPendonorPage(),
          middlewares: [RoleMiddleware('admin')],
        ),
        GetPage(
          name: '/stok-darah',
          page: () => const StokDarahPage(),
          middlewares: [RoleMiddleware('admin')],
        ),
        GetPage(
          name: '/jadwal-donor',
          page: () => const JadwalDonorPage(),
          middlewares: [RoleMiddleware('admin')],
        ),

        // =========================
        //          USER
        // =========================
        GetPage(
          name: '/user-dashboard',
          page: () => const UserDashboardScreen(),
          middlewares: [RoleMiddleware('user')],
        ),
        GetPage(
          name: '/jadwal',
          page: () => const UserJadwalScreen(),
          middlewares: [RoleMiddleware('user')],
        ),
        GetPage(
          name: '/riwayat',
          page: () => const UserRiwayatScreen(),
          middlewares: [RoleMiddleware('user')],
        ),
        GetPage(
          name: '/profil',
          page: () => const UserProfilScreen(),
          middlewares: [RoleMiddleware('user')],
        ),
      ],
    );
  }
}
