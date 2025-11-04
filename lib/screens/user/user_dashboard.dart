import 'package:flutter/material.dart';
import 'package:donor_darah/screens/widgets/user_navbar.dart';

class UserDashboardScreen extends StatelessWidget {
  const UserDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Beranda"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: const UserNavBar(currentIndex: 0),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _dashboardCard(
              Icons.bloodtype, "Status Donor", "Terakhir donor: 10 Juni 2025"),
          _dashboardCard(
              Icons.calendar_month, "Jadwal Berikutnya", "15 Desember 2025"),
          _dashboardCard(Icons.favorite, "Golongan Darah", "A+"),
        ],
      ),
    );
  }

  Widget _dashboardCard(IconData icon, String title, String desc) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.redAccent.withOpacity(0.15),
          child: Icon(icon, color: Colors.redAccent),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        subtitle: Text(desc),
      ),
    );
  }
}
