import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

class JadwalDonorPage extends StatelessWidget {
  const JadwalDonorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final jadwal = [
      {"tanggal": "2025-12-05", "lokasi": "RSU Kota", "waktu": "09:00 - 12:00"},
      {
        "tanggal": "2025-12-12",
        "lokasi": "Puskesmas Utama",
        "waktu": "13:00 - 16:00",
      },
      {
        "tanggal": "2025-12-20",
        "lokasi": "Balai Desa",
        "waktu": "08:00 - 11:00",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Jadwal Donor"),
        backgroundColor: AppTheme.primaryColor, // Use primary color
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: jadwal.map((item) {
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.event, color: AppTheme.primaryColor),
                ),
                title: Text(
                  item["tanggal"]!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      item["lokasi"]!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(item["waktu"]!),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
