import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller.dart';

class UserRiwayatScreen extends StatelessWidget {
  const UserRiwayatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get controller
    final UserController userController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Donor"),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (userController.riwayatDonor.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history_rounded,
                  size: 80,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  "Belum ada riwayat donor",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: userController.riwayatDonor.length,
          itemBuilder: (context, i) {
            final item = userController.riwayatDonor[i];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/riwayat_detail',
                  arguments: item,
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.bloodtype_rounded,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  title: Text(
                    item['tempat'] ?? '-',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item['tgl'] ?? '-',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
