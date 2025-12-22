import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/data_controller.dart';

class StokDarahPage extends StatelessWidget {
  const StokDarahPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DataController>();

    return Obx(
      () => ListView(
        padding: const EdgeInsets.all(16),
        children: controller.stokDarah.entries.map((item) {
          final gol = item.key;
          final stok = item.value;
          final status = stok >= 20
              ? 'Aman'
              : (stok >= 10 ? 'Perhatian' : 'Kritis');

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              title: Text(
                "Golongan: $gol",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Stok: $stok kantong"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.red,
                    ),
                    onPressed: () => controller.updateStok(gol, -1),
                  ),
                  SizedBox(
                    width: 30,
                    child: Text(
                      "$stok",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.green,
                    ),
                    onPressed: () => controller.updateStok(gol, 1),
                  ),
                  const SizedBox(width: 8),
                  _statusDot(status),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _statusDot(String status) {
    Color color;
    switch (status) {
      case "Kritis":
        color = Colors.red;
        break;
      case "Perhatian":
        color = Colors.orange;
        break;
      default:
        color = Colors.green;
    }
    return CircleAvatar(radius: 6, backgroundColor: color);
  }
}
