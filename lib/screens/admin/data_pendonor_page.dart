import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_theme.dart';
import '../../controllers/data_controller.dart';

class DataPendonorPage extends StatelessWidget {
  const DataPendonorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DataController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Pendonor"),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Obx(
        () => ListView(
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
            ...controller.pendonorList.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _buildPendonorTile(context, index, item);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPendonorTile(
    BuildContext context,
    int index,
    Map<String, String> item,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(child: Text(item['nama']![0])),
        title: Text(item['nama']!),
        subtitle: Text(
          "Golongan: ${item['golongan']}\nTerakhir donor: ${item['terakhir']}",
        ),
        trailing: TextButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/admin/pendonor_detail',
              arguments: {'index': index, 'data': item},
            );
          },
          child: const Text(
            "Detail",
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
