import 'package:flutter/material.dart';

class KelolaLaporanPage extends StatefulWidget {
  const KelolaLaporanPage({super.key});

  @override
  State<KelolaLaporanPage> createState() => _KelolaLaporanPageState();
}

class _KelolaLaporanPageState extends State<KelolaLaporanPage> {
  List<Map<String, String>> reports = [
    {'id': 'r1', 'title': 'Laporan Bulanan - Oktober 2025', 'date': '2025-10-31'},
    {'id': 'r2', 'title': 'Ringkasan Pendonor 2025', 'date': '2025-11-01'},
  ];

  void _generateReport() {
    // mock generate
    setState(() {
      reports.insert(0, {
        'id': 'r${reports.length + 1}',
        'title': 'Laporan baru - ${DateTime.now().toIso8601String()}',
        'date': DateTime.now().toIso8601String().split('T').first,
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Laporan dibuat (mock)')));
  }

  void _viewReport(Map<String, String> r) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(r['title']!),
        content: Text('Preview laporan ${r['title']} (mock).'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Download (mock)')));
            },
            child: const Text('Download'),
          )
        ],
      ),
    );
  }

  void _deleteReport(Map<String, String> r) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Laporan'),
        content: Text('Hapus laporan "${r['title']}" ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                reports.removeWhere((rep) => rep['id'] == r['id']);
              });
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Laporan'),
        actions: [
          IconButton(
            onPressed: _generateReport,
            icon: const Icon(Icons.add_chart),
            tooltip: 'Buat Laporan',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.separated(
          itemCount: reports.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, i) {
            final r = reports[i];
            return ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: Text(r['title']!),
              subtitle: Text('Tanggal: ${r['date']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: () => _viewReport(r), icon: const Icon(Icons.visibility)),
                  IconButton(onPressed: () => _deleteReport(r), icon: const Icon(Icons.delete, color: Colors.red)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
