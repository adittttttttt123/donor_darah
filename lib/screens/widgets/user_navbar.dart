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

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = currentIndex == index;
          return GestureDetector(
            onTap: () {
              if (!isSelected) {
                Navigator.pushReplacementNamed(
                  context,
                  item['route'] as String,
                );
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: isSelected
                  ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                  : const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.redAccent.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    item['icon'] as IconData,
                    color: isSelected ? Colors.redAccent : Colors.grey,
                    size: 24,
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    Text(
                      item['label'] as String,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
