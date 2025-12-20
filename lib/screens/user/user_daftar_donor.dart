import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import 'package:get/get.dart';
import '../../controllers/data_controller.dart';
import '../../controllers/user_controller.dart';

class UserDaftarDonorScreen extends StatefulWidget {
  const UserDaftarDonorScreen({super.key});

  @override
  State<UserDaftarDonorScreen> createState() => _UserDaftarDonorScreenState();
}

class _UserDaftarDonorScreenState extends State<UserDaftarDonorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nikController = TextEditingController();
  final _beratBadanController = TextEditingController();

  // Data dari arguments
  late String lokasi;
  late String tanggal;
  late String jam;

  bool _isSehat = false;
  bool _tidakMinumObat = false;
  bool _tidakHamil = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    lokasi = args?['tempat'] ?? 'Lokasi Tidak Diketahui';
    tanggal = args?['tanggal'] ?? 'Tanggal Tidak Diketahui';
    jam = args?['jam'] ?? 'Waktu Tidak Diketahui';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulir Pendaftaran"),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(),
              const SizedBox(height: 24),
              const Text(
                "Data Diri Pendonor",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nikController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "NIK (KTP)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.credit_card),
                ),
                validator: (value) => value!.isEmpty ? "Harap isi NIK" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _beratBadanController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Berat Badan (kg)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.monitor_weight),
                  suffixText: "kg",
                ),
                validator: (value) =>
                    value!.isEmpty ? "Harap isi Berat Badan" : null,
              ),

              const SizedBox(height: 24),
              const Text(
                "Kuesioner Kesehatan Singkat",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              CheckboxListTile(
                value: _isSehat,
                onChanged: (val) => setState(() => _isSehat = val!),
                title: const Text("Saya merasa sehat hari ini"),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: AppTheme.primaryColor,
              ),
              CheckboxListTile(
                value: _tidakMinumObat,
                onChanged: (val) => setState(() => _tidakMinumObat = val!),
                title: const Text(
                  "Saya tidak sedang minum obat-obatan tertentu (antibiotik, aspirelet, dll) dalam 3 hari terakhir",
                ),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: AppTheme.primaryColor,
              ),
              CheckboxListTile(
                value: _tidakHamil,
                onChanged: (val) => setState(() => _tidakHamil = val!),
                title: const Text(
                  "Saya tidak sedang hamil/menyusui/haid (khusus wanita)",
                ),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: AppTheme.primaryColor,
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _submitForm,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                  ),
                  child: const Text(
                    "Daftar Sekarang",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Row(
        children: [
          const Icon(Icons.event_note, color: AppTheme.primaryColor, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lokasi,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(tanggal, style: const TextStyle(color: Colors.grey)),
                Text(jam, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (!_isSehat || !_tidakMinumObat) {
        Get.snackbar(
          "Peringatan",
          "Anda harus memenuhi syarat kesehatan untuk mendonor.",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      final userController = Get.find<UserController>();
      final dataController = Get.find<DataController>();

      // Add to global state
      dataController.addPendonor(
        userController.nama.value,
        userController.golDarah.value,
        tanggal,
      );

      Navigator.pushNamed(
        context,
        '/daftar_sukses',
        arguments: {'tempat': lokasi, 'tanggal': tanggal, 'jam': jam},
      );
    }
  }
}
