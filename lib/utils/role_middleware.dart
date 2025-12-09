import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RoleMiddleware extends GetMiddleware {
  final String allowedRole;

  RoleMiddleware(this.allowedRole);

  @override
  RouteSettings? redirect(String? route) {
    final box = GetStorage();
    final role = box.read('role') ?? 'none';

    if (role != allowedRole) {
      // Jika role salah → redirect otomatis
      if (role == 'admin') {
        return const RouteSettings(name: '/admin-dashboard');
      } else if (role == 'user') {
        return const RouteSettings(name: '/user-dashboard');
      } else {
        return const RouteSettings(name: '/login');
      }
    }

    return null;
  }
}
