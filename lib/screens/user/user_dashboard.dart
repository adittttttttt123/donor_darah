import 'package:donor_darah/screens/widgets/user_navbar.dart';
import 'package:flutter/material.dart';

class UserDashboardScreen extends StatelessWidget {
  const UserDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Beranda DonorDarahApp'),
        backgroundColor: Colors.redAccent,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBar: const UserNavBar(currentIndex: 0),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _infoCard(
            title: 'Status Donor Terakhir',
            content: 'Terakhir donor: 10 Juni 2025 di PMI Boyolali 🏥',
            icon: Icons.bloodtype,
          ),
          _infoCard(
            title: 'Jadwal Donor Berikutnya',
            content: '15 Desember 2025 - RSUD Pandan Arang ⏰',
            icon: Icons.calendar_month,
          ),
          _infoCard(
            title: 'Golongan Darah Anda',
            content: '🩸 A+',
            icon: Icons.favorite,
          ),
        ],
      ),
    );
  }

  Widget _infoCard(
      {required String title, required String content, required IconData icon}) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Colors.redAccent, size: 35),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content),
      ),
    );
  }
}
  