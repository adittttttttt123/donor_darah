import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

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
      appBar: AppBar(
        title: const Text("Pengaturan"),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsItem(
            icon: Icons.person,
            title: "Profil Saya",
            onTap: () {
              Navigator.pushNamed(context, '/profil');
            },
          ),
          _buildSettingsItem(
            icon: Icons.dark_mode,
            title: "Tema Gelap",
            trailing: Switch(
              value: isDarkTheme,
              activeColor: AppTheme.primaryColor,
              onChanged: (value) {
                setState(() {
                  isDarkTheme = value;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Fitur ganti tema belum tersedia penuh"),
                  ),
                );
              },
            ),
            onTap: () {},
          ),
          const Divider(),
          _buildSettingsItem(
            icon: Icons.help,
            title: "Bantuan & Dukungan",
            onTap: () {
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
                      child: const Text("Tutup"),
                    ),
                  ],
                ),
              );
            },
          ),
          _buildSettingsItem(
            icon: Icons.info,
            title: "Tentang Aplikasi",
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "Donor Darah App",
                applicationVersion: "1.0.0",
                applicationIcon: const Icon(Icons.bloodtype, color: Colors.red),
                children: const [
                  Text("Aplikasi untuk memudahkan donor darah."),
                ],
              );
            },
          ),
          _buildSettingsItem(
            icon: Icons.logout,
            title: "Keluar Akun",
            onTap: () {
              // Using Get.offAllNamed since GetX is used elsewhere,
              // or Navigator.pushNamedAndRemoveUntil if Get context is tricky,
              // but project seems to use Get generally or mixed.
              // The profile page used Get.offAllNamed('/').
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.primaryColor),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
