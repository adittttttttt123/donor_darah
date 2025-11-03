import 'package:flutter/material.dart';

class UserNavBar extends StatelessWidget {
  final int currentIndex;
  const UserNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.home, 'label': 'Home', 'route': '/dashboard'},
      {'icon': Icons.event, 'label': 'Jadwal', 'route': '/jadwal'},
      {'icon': Icons.history, 'label': 'Riwayat', 'route': '/riwayat'},
      {'icon': Icons.person, 'label': 'Profil', 'route': '/profil'},
    ];

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: Colors.redAccent,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        Navigator.pushReplacementNamed(context, items[index]['route'] as String);
      },
      items: items
          .map(
            (e) => BottomNavigationBarItem(
              icon: Icon(e['icon'] as IconData),
              label: e['label'] as String,
            ),
          )
          .toList(),
    );
  }
}
