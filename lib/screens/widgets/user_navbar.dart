import 'package:flutter/material.dart';

class UserNavBar extends StatelessWidget {
  final int currentIndex;
  const UserNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Beranda', 'route': '/dashboard'},
      {'icon': Icons.event_rounded, 'label': 'Jadwal', 'route': '/jadwal'},
      {'icon': Icons.history_rounded, 'label': 'Riwayat', 'route': '/riwayat'},
      {'icon': Icons.person_rounded, 'label': 'Profil', 'route': '/profil'},
    ];

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        if (index != currentIndex) {
          Navigator.pushReplacementNamed(context, items[index]['route'] as String);
        }
      },
      destinations: items
          .map(
            (e) => NavigationDestination(
              icon: Icon(e['icon'] as IconData),
              label: e['label'] as String,
            ),
          )
          .toList(),
    );
  }
}
