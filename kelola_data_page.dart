import 'package:flutter/material.dart';

class KelolaDataPage extends StatefulWidget {
  const KelolaDataPage({super.key});

  @override
  State<KelolaDataPage> createState() => _KelolaDataPageState();
}

class _KelolaDataPageState extends State<KelolaDataPage> {
  List<Map<String, String>> pendonor = [
    {'id': '1', 'nama': 'Andi Setiawan', 'golongan': 'O+', 'hp': '081234567890'},
    {'id': '2', 'nama': 'Siti Aminah', 'golongan': 'A+', 'hp': '081298765432'},
    {'id': '3', 'nama': 'Budi Santoso', 'golongan': 'B+', 'hp': '081211122233'},
  ];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaC = TextEditingController();
  final TextEditingController _golC = TextEditingController();
  final TextEditingController _hpC = TextEditingController();

  void _openForm({Map<String, String>? item}) {
    if (item != null) {
      _namaC.text = item['nama'] ?? '';
      _golC.text = item['golongan'] ?? '';
      _hpC.text = item['hp'] ?? '';
    } else {
      _namaC.clear();
      _golC.clear();
      _hpC.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(item == null ? 'Tambah Pendonor' : 'Edit Pendonor'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _namaC,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (v) => v == null || v.isEmpty ? 'Harus diisi' : null,
              ),
              TextFormField(
                controller: _golC,
                decoration: const InputDecoration(labelText: 'Golongan Darah'),
                validator: (v) => v == null || v.isEmpty ? 'Harus diisi' : null,
              ),
              TextFormField(
                controller: _hpC,
                decoration: const InputDecoration(labelText: 'No HP'),
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
                    final newId = (pendonor.length + 1).toString();
                    pendonor.add({
                      'id': newId,
                      'nama': _namaC.text,
                      'golongan': _golC.text,
                      'hp': _hpC.text,
                    });
                  } else {
                    final idx = pendonor.indexWhere((p) => p['id'] == item['id']);
                    if (idx != -1) {
                      pendonor[idx] = {
                        'id': item['id']!,
                        'nama': _namaC.text,
                        'golongan': _golC.text,
                        'hp': _hpC.text,
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
        title: const Text('Hapus Pendonor'),
        content: Text('Hapus ${item['nama']} ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                pendonor.removeWhere((p) => p['id'] == item['id']);
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
        title: const Text('Kelola Data Pendonor'),
        actions: [
          IconButton(
            onPressed: () => _openForm(),
            icon: const Icon(Icons.add),
            tooltip: 'Tambah Pendonor',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.separated(
          itemCount: pendonor.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, i) {
            final p = pendonor[i];
            return ListTile(
              leading: CircleAvatar(child: Text(p['nama']![0])),
              title: Text(p['nama']!),
              subtitle: Text('Gol: ${p['golongan']} • HP: ${p['hp']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _openForm(item: p),
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () => _confirmDelete(p),
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
