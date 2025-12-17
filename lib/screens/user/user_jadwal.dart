import 'package:flutter/material.dart';
import 'package:donor_darah/screens/widgets/user_navbar.dart';

class UserJadwalScreen extends StatelessWidget {
  const UserJadwalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final jadwalList = [
      {"tempat": "PMI Boyolali", "tanggal": "10 Desember 2025"},
      {"tempat": "RSUD Pandan Arang", "tanggal": "15 Desember 2025"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Jadwal Donor"), centerTitle: true),
      bottomNavigationBar: const UserNavBar(currentIndex: 1),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: jadwalList.length,
        itemBuilder: (context, index) {
          final item = jadwalList[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              title: Text(
                item["tempat"]!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item["tanggal"]!),
              trailing: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: const Text("Daftar"),
              ),
            ),
          );
        },
      ),
    );
  }
}
