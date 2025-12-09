import 'package:flutter/material.dart';

class DataPendonorPage extends StatelessWidget {
  const DataPendonorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Pendonor"),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: "Cari pendonor...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // List contoh pendonor
          _buildPendonorTile("Andi Setiawan", "O+", "2025-10-12"),
          _buildPendonorTile("Siti Aminah", "A+", "2025-09-20"),
          _buildPendonorTile("Budi Santoso", "B+", "2025-07-01"),
          _buildPendonorTile("Rina Marlina", "AB-", "2025-06-15"),
        ],
      ),
    );
  }

  Widget _buildPendonorTile(String nama, String gol, String terakhir) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(child: Text(nama[0])),
        title: Text(nama),
        subtitle: Text("Golongan: $gol\nTerakhir donor: $terakhir"),
        trailing: const Text("Detail",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
