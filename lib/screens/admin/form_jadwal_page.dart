import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import 'package:get/get.dart';
import '../../controllers/data_controller.dart';
import 'package:intl/intl.dart';

class FormJadwalPage extends StatefulWidget {
  const FormJadwalPage({super.key});

  @override
  State<FormJadwalPage> createState() => _FormJadwalPageState();
}

class _FormJadwalPageState extends State<FormJadwalPage> {
  final _formKey = GlobalKey<FormState>();
  final _lokasiController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _jamController = TextEditingController();

  // To verify if we are editing, we can check arguments
  // But for simple prototype we will just assume "Add" unless arg is passed
  // (Not implementing full Edit logic for this specific step to keep it simple, primarily Add)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Jadwal Donor"),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _lokasiController,
                decoration: InputDecoration(
                  labelText: "Lokasi / Tempat",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.location_on),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (v) =>
                    v!.isEmpty ? "Lokasi tidak boleh kosong" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tanggalController,
                readOnly: true,
                onTap: _pickDate,
                decoration: InputDecoration(
                  labelText: "Tanggal",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.calendar_today),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (v) => v!.isEmpty ? "Tanggal harus diisi" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jamController,
                decoration: InputDecoration(
                  labelText: "Jam Operasional (misal: 08:00 - 12:00)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.access_time),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (v) => v!.isEmpty ? "Jam tidak boleh kosong" : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveJadwal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "SIMPAN JADWAL",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      _tanggalController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void _saveJadwal() {
    if (_formKey.currentState!.validate()) {
      final controller = Get.find<DataController>();
      controller.addJadwal(
        _lokasiController.text,
        _tanggalController.text,
        _jamController.text,
      );
      Get.back();
      Get.snackbar(
        "Sukses",
        "Jadwal berhasil ditambahkan",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
