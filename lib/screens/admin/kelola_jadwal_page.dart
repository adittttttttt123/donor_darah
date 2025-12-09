import 'package:flutter/material.dart';

class KelolaJadwalPage extends StatefulWidget {
  const KelolaJadwalPage({super.key});

  @override
  State<KelolaJadwalPage> createState() => _KelolaJadwalPageState();
}

class _KelolaJadwalPageState extends State<KelolaJadwalPage> {
  List<Map<String, String>> schedules = [
    {'id': '1', 'lokasi': 'RSUD Kota', 'tanggal': '2025-11-15', 'jam': '08:00 - 12:00'},
    {'id': '2', 'lokasi': 'Kampus ABC', 'tanggal': '2025-11-20', 'jam': '09:00 - 13:00'},
  ];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _lokC = TextEditingController();
  final TextEditingController _tglC = TextEditingController();
  final TextEditingController _jamC = TextEditingController();

  void _openForm({Map<String, String>? item}) {
    if (item != null) {
      _lokC.text = item['lokasi'] ?? '';
      _tglC.text = item['tanggal'] ?? '';
      _jamC.text = item['jam'] ?? '';
    } else {
      _lokC.clear();
      _tglC.clear();
      _jamC.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(item == null ? 'Tambah Jadwal' : 'Edit Jadwal'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _lokC,
                decoration: const InputDecoration(labelText: 'Lokasi'),
                validator: (v) => v == null || v.isEmpty ? 'Harus diisi' : null,
              ),
              TextFormField(
                controller: _tglC,
                decoration: const InputDecoration(labelText: 'Tanggal (YYYY-MM-DD)'),
                validator: (v) => v == null || v.isEmpty ? 'Harus diisi' : null,
              ),
              TextFormField(
                controller: _jamC,
                decoration: const InputDecoration(labelText: 'Jam (e.g. 08:00 - 12:00)'),
                validator: (v) => v == null || v.isEmpty ? 'Harus diisi' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  if (item == null) {
                    final newId = (schedules.length + 1).toString();
                    schedules.add({
                      'id': newId,
                      'lokasi': _lokC.text,
                      'tanggal': _tglC.text,
                      'jam': _jamC.text,
                    });
                  } else {
                    final idx = schedules.indexWhere((s) => s['id'] == item['id']);
                    if (idx != -1) {
                      schedules[idx] = {
                        'id': item['id']!,
                        'lokasi': _lokC.text,
                        'tanggal': _tglC.text,
                        'jam': _jamC.text,
                      };
                    }
                  }
                });

                Navigator.pop(context);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Map<String, String> item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Jadwal'),
        content: Text('Hapus jadwal di ${item['lokasi']} (${item['tanggal']}) ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                schedules.removeWhere((s) => s['id'] == item['id']);
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
        title: const Text('Kelola Jadwal Donor'),
        actions: [
          IconButton(
            onPressed: () => _openForm(),
            icon: const Icon(Icons.add),
            tooltip: 'Tambah Jadwal',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.separated(
          itemCount: schedules.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, i) {
            final s = schedules[i];
            return ListTile(
              leading: const Icon(Icons.event_note),
              title: Text(s['lokasi']!),
              subtitle: Text('${s['tanggal']} • ${s['jam']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: () => _openForm(item: s), icon: const Icon(Icons.edit)),
                  IconButton(
                    onPressed: () => _confirmDelete(s),
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
