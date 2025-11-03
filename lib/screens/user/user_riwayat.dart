import 'package:donor_darah/screens/widgets/user_navbar.dart';
import 'package:flutter/material.dart';

class UserRiwayatScreen extends StatelessWidget {
  const UserRiwayatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final riwayat = [
      {'tgl': '10 Juni 2025', 'tempat': 'PMI Boyolali', 'gol': 'A+'},
      {'tgl': '1 Maret 2025', 'tempat': 'RSUD Pandan Arang', 'gol': 'A+'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Donor"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      bottomNavigationBar: const UserNavBar(currentIndex: 2),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: riwayat.length,
        itemBuilder: (context, i) {
          final item = riwayat[i];
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.history, color: Colors.redAccent),
              title: Text(item['tempat']!),
              subtitle: Text('${item['tgl']} - Golongan: ${item['gol']}'),
            ),
          );
        },
      ),
    );
  }
}
