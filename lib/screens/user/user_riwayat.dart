import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import 'package:donor_darah/screens/widgets/user_navbar.dart';

class UserRiwayatScreen extends StatelessWidget {
  const UserRiwayatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> riwayat = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Donor"),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: const UserNavBar(currentIndex: 2),
      body: riwayat.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    "Belum ada riwayat donor",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: riwayat.length,
              itemBuilder: (context, i) {
                final item = riwayat[i];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(
                      Icons.history,
                      color: AppTheme.primaryColor,
                    ),
                    title: Text(
                      item['tempat']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(item['tgl']!),
                  ),
                );
              },
            ),
    );
  }
}
