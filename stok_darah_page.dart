import 'package:flutter/material.dart';

class StokDarahPage extends StatelessWidget {
  const StokDarahPage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      {"gol": "A+", "stok": 40, "status": "Perhatian"},
      {"gol": "A-", "stok": 12, "status": "Kritis"},
      {"gol": "B+", "stok": 50, "status": "Aman"},
      {"gol": "B-", "stok": 9, "status": "Kritis"},
      {"gol": "AB+", "stok": 6, "status": "Kritis"},
      {"gol": "AB-", "stok": 2, "status": "Kritis"},
      {"gol": "O+", "stok": 82, "status": "Aman"},
      {"gol": "O-", "stok": 18, "status": "Perhatian"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Stok Darah"),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: data.map((item) {
          return Card(
            child: ListTile(
              title: Text("Golongan: ${item['gol']}"),
              subtitle: Text("Stok: ${item['stok']} kantong"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _statusDot(item['status'] as String),
                  const SizedBox(width: 6),
                  Text(item['status'] as String),
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
