import 'package:flutter/material.dart';

class JadwalDonorPage extends StatelessWidget {
  const JadwalDonorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final jadwal = [
      {
        "tanggal": "2025-12-05",
        "lokasi": "RSU Kota",
        "waktu": "09:00 - 12:00"
      },
      {
        "tanggal": "2025-12-12",
        "lokasi": "Puskesmas Utama",
        "waktu": "13:00 - 16:00"
      },
      {
        "tanggal": "2025-12-20",
        "lokasi": "Balai Desa",
        "waktu": "08:00 - 11:00"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Jadwal Donor"),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: jadwal.map((item) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.red),
              title: Text(item["tanggal"]!),
              subtitle: Text("${item["lokasi"]}\n${item["waktu"]}"),
            ),
          );
        }).toList(),
      ),
    );
  }
}
