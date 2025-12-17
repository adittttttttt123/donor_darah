import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import 'package:get/get.dart';
import '../../controllers/data_controller.dart';

class DetailPendonorPage extends StatefulWidget {
  const DetailPendonorPage({super.key});

  @override
  State<DetailPendonorPage> createState() => _DetailPendonorPageState();
}

class _DetailPendonorPageState extends State<DetailPendonorPage> {
  // Arguments: { 'index': int, 'data': Map<String, String> }
  late int index;
  late Map<String, String> data;

  final _namaController = TextEditingController();
  String? _selectedGolDarah;
  final _terakhirController = TextEditingController();

  final List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      index = args['index'];
      data = args['data'] as Map<String, String>;
      _namaController.text = data['nama'] ?? '';
      _selectedGolDarah = data['golongan'];
      _terakhirController.text = data['terakhir'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pendonor"),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: const NetworkImage(
                      "https://cdn-icons-png.flaticon.com/512/9131/9131529.png",
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: AppTheme.primaryColor,
                      radius: 18,
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            TextFormField(
              controller: _namaController,
              decoration: InputDecoration(
                labelText: "Nama Lengkap",
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _selectedGolDarah,
              items: _bloodTypes
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedGolDarah = val),
              decoration: InputDecoration(
                labelText: "Golongan Darah",
                prefixIcon: const Icon(Icons.bloodtype),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _terakhirController,
              decoration: InputDecoration(
                labelText: "Terakhir Donor",
                prefixIcon: const Icon(Icons.history),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "SIMPAN PERUBAHAN",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveData() {
    final controller = Get.find<DataController>();
    // Update data locally in controller list
    // Note: For real app, use ID. Here using index for simplicity.
    controller.pendonorList[index] = {
      'nama': _namaController.text,
      'golongan': _selectedGolDarah ?? 'Unknown',
      'terakhir': _terakhirController.text,
    };
    controller.pendonorList.refresh(); // Refresh Obx

    Get.back();
    Get.snackbar(
      "Sukses",
      "Data pendonor diperbarui",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
