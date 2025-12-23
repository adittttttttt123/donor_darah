import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_theme.dart';
import '../../controllers/theme_controller.dart';
import '../../controllers/user_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "Pengaturan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader("Akun Saya"),
          const SizedBox(height: 12),
          _buildModernSettingItem(
            icon: Icons.person_outline_rounded,
            title: "Profil Saya",
            subtitle: "Lihat dan atur profil Anda",
            onTap: () => Navigator.pushNamed(context, '/profil'),
          ),
          const SizedBox(height: 12),
          _buildModernSettingItem(
            icon: Icons.lock_reset_rounded,
            title: "Ganti Password",
            subtitle: "Ubah kata sandi akun Anda",
            onTap: () {
              _showChangePasswordDialog(context);
            },
          ),
          const SizedBox(height: 24),
          _buildSectionHeader("Preferensi"),
          const SizedBox(height: 12),
          _buildModernSettingItem(
            icon: Icons.dark_mode_outlined,
            title: "Tema Gelap",
            subtitle: "Sesuaikan tampilan aplikasi",
            trailing: Obx(() {
              // Get controller - ensure it's found (should be put in main)
              final themeController = Get.find<ThemeController>();
              return Switch(
                value: themeController.isDarkMode,
                activeThumbColor: AppTheme.primaryColor,
                onChanged: (value) {
                  themeController.toggleTheme();
                },
              );
            }),
            onTap: () {},
          ),
          const SizedBox(height: 24),
          _buildSectionHeader("Dukungan"),
          const SizedBox(height: 12),
          _buildModernSettingItem(
            icon: Icons.help_outline_rounded,
            title: "Bantuan & Dukungan",
            subtitle: "Butuh bantuan? Hubungi kami",
            onTap: () => _showHelpDialog(context),
          ),
          const SizedBox(height: 12),
          _buildModernSettingItem(
            icon: Icons.info_outline_rounded,
            title: "Tentang Aplikasi",
            subtitle: "Versi 6(1.0.1)",
            onTap: () => _showAboutDialog(context),
          ),
          const SizedBox(height: 24),
          _buildModernSettingItem(
            icon: Icons.logout_rounded,
            title: "Keluar Akun",
            subtitle: "Keluar dari sesi ini",
            iconColor: Colors.redAccent,
            textColor: Colors.redAccent,
            isDestructive: true,
            onTap: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildModernSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Widget? trailing,
    Color? iconColor,
    Color? textColor,
    bool isDestructive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100), // Add subtle border
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.02), // Very subtle shadow
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDestructive
                        ? Colors.red.shade50
                        : Colors.red.shade50, // Red tint
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? Colors.redAccent, // Red Accent
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor ?? Colors.grey.shade800,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null)
                  trailing
                else
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey.shade300,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Bantuan & Dukungan"),
        content: const Text(
          "Jika Anda mengalami kendala, silakan hubungi kami di support@donordarah.com",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Tutup",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: "Donor Darah App",
      applicationVersion: "1.0.0",
      applicationIcon: const Icon(
        Icons.favorite,
        color: Colors.redAccent,
        size: 40,
      ),
      children: const [
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text(
            "Aplikasi ini dibuat untuk memudahkan masyarakat dalam melakukan kegiatan donor darah dan mengakses informasi terkait stok darah.",
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController passController = TextEditingController();
    final TextEditingController confirmPassController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ganti Password"),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: passController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password Baru",
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: (v) =>
                    v!.length < 6 ? "Password minimal 6 karakter" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPassController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Konfirmasi Password",
                  prefixIcon: Icon(Icons.lock_reset),
                ),
                validator: (v) {
                  if (v != passController.text) {
                    return "Password tidak cocok";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context); // Close dialog first

                try {
                  final userController = Get.find<UserController>();
                  await userController.updatePassword(passController.text);
                } catch (e) {
                  Get.snackbar("Error", "Controller tidak ditemukan");
                }
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }
}
