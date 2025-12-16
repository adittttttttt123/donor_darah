import 'package:donor_darah/screens/user/user_dashboard.dart';
import 'package:donor_darah/screens/user/user_jadwal.dart';
import 'package:donor_darah/screens/user/user_profil.dart';
import 'package:donor_darah/screens/user/user_riwayat.dart';
import 'package:flutter/material.dart';

class UserNavbar extends StatefulWidget {
  final int currentIndex;
  const UserNavbar({super.key, required this.currentIndex});

  @override
  State<UserNavbar> createState() => _UserNavbarState();
}

class _UserNavbarState extends State<UserNavbar> {
  late int _currentIndex;

  final List<Widget> _pages = const [
    UserDashboardScreen(),
    UserJadwalScreen(),
    UserRiwayatScreen(),
    UserProfilScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Jadwal'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
