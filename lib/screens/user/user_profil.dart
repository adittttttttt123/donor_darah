import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'user_edit_profil.dart';
import '../../controllers/user_controller.dart';
import '../../core/app_theme.dart';

class UserProfilScreen extends StatelessWidget {
  const UserProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),

      appBar: AppBar(
        title: const Text("Profil Pengguna"),
        centerTitle: true,
        elevation: 4,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offNamed('/dashboard');
          },
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => CircleAvatar(
                    radius: 60,
                    backgroundImage: controller.profileImageBytes.value != null
                        ? MemoryImage(controller.profileImageBytes.value!)
                        : NetworkImage(controller.profileImage.value)
                              as ImageProvider,
                  ),
                ),
                const SizedBox(height: 20),

                // NAMA — dikosongkan
                Obx(
                  () => Text(
                    controller.nama.value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                Obx(
                  () => Text(
                    "Golongan Darah: ${controller.golDarah.value}",
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),

                const SizedBox(height: 25),
                const Divider(height: 30, thickness: 1.2),

                // DETAIL INFORMASI — dikosongkan
                Obx(
                  () => _infoTile(
                    Icons.phone_android,
                    "Nomor HP",
                    controller.noHp.value,
                  ),
                ),
                Obx(
                  () =>
                      _infoTile(Icons.home, "Alamat", controller.alamat.value),
                ),
                Obx(
                  () => _infoTile(
                    Icons.calendar_month,
                    "Tanggal Lahir",
                    controller.tglLahir.value,
                  ),
                ),

                const SizedBox(height: 25),

                FilledButton.icon(
                  onPressed: () {
                    Get.to(() => const UserEditProfilScreen());
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit Profil"),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                OutlinedButton.icon(
                  onPressed: () {
                    Get.offAllNamed('/');
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Keluar Akun"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: const BorderSide(color: AppTheme.primaryColor),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primaryColor),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
