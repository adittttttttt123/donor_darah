import 'package:flutter/material.dart';
import 'package:donor_darah/screens/widgets/user_navbar.dart';

class UserRiwayatScreen extends StatelessWidget {
  const UserRiwayatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final riwayat = [
      {"tgl": "10 Juni 2025", "tempat": "PMI Boyolali"},
      {"tgl": "1 Maret 2025", "tempat": "RSUD Pandan Arang"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Donor"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: const UserNavBar(currentIndex: 2),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: riwayat.length,
        itemBuilder: (context, i) {
          final item = riwayat[i];
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.history, color: Colors.redAccent),
              title: Text(item['tempat']!,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(item['tgl']!),
            ),
          );
        },
      ),
    );
  }
}
