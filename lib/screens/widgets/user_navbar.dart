import 'package:flutter/material.dart';

class UserNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const UserNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Beranda'},
      {'icon': Icons.calendar_today_rounded, 'label': 'Jadwal'},
      {'icon': Icons.history_rounded, 'label': 'Riwayat'},
      {'icon': Icons.settings_rounded, 'label': 'Pengaturan'},
    ];

    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
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
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              padding: isSelected
                  ? const EdgeInsets.symmetric(horizontal: 20, vertical: 12)
                  : const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors
                          .red
                          .shade50 // Red tint
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    item['icon'] as IconData,
                    color: isSelected ? Colors.redAccent : Colors.grey.shade400,
                    size: 24,
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    Text(
                      item['label'] as String,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
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
