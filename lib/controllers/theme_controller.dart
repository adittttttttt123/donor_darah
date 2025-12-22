import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  // Observable boolean
  final _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;

  // return ThemeMode based on state
  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    // Load local storage
    _isDarkMode.value = _box.read(_key) ?? false;
  }

  void saveTheme(bool isDark) {
    _isDarkMode.value = isDark;
    _box.write(_key, isDark);

    // Update Theme immediately in GetMaterialApp
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() {
    saveTheme(!isDarkMode);
  }
}
