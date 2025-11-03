import 'package:donor_darah/screens/widgets/user_navbar.dart';
import 'package:flutter/material.dart';

class UserJadwalScreen extends StatelessWidget {
  const UserJadwalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jadwal Donor"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      bottomNavigationBar: const UserNavBar(currentIndex: 1),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _jadwalCard(
              "PMI Boyolali", "10 Desember 2025", "📍 Jl. Pandanaran No.12"),
          _jadwalCard(
              "RSUD Pandan Arang", "15 Desember 2025", "📍 Boyolali Kota"),
        ],
      ),
    );
  }

  Widget _jadwalCard(String lokasi, String tanggal, String alamat) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        title: Text(lokasi, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$tanggal\n$alamat'),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
          ),
          onPressed: () {},
          child: const Text("Daftar"),
        ),
      ),
    );
  }
}
