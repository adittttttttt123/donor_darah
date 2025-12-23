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
    // Change 'tempat' to 'lokasi' to match what comes from UserJadwalScreen
    lokasi = args?['lokasi'] ?? 'Lokasi Tidak Diketahui';
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
              const SizedBox(height: 16),

              // Syarat Donor Expansion Tile
              Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: const Text(
                    "Syarat Dasar Donor Darah",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  iconColor: AppTheme.primaryColor,
                  collapsedIconColor: AppTheme.primaryColor,
                  tilePadding: EdgeInsets.zero,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          _RequirementItem(
                            "Usia 17-60 tahun (usia 17 tahun diperbolehkan donor bila mendapat izin tertulis dari orangtua).",
                          ),
                          _RequirementItem("Berat badan minimal 45 kg."),
                          _RequirementItem(
                            "Temperatur tubuh 36,6 - 37,5 derajat Celcius.",
                          ),
                          _RequirementItem(
                            "Tekanan darah normal (Sistole 100-160 mmHg, Diastole 70-100 mmHg).",
                          ),
                          _RequirementItem(
                            "Denyut nadi teratur (50-100 kali/menit).",
                          ),
                          _RequirementItem(
                            "Hemoglobin perempuan minimal 12 g/dL, laki-laki minimal 12,5 g/dL.",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                "Data Diri Pendonor",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nikController,
                keyboardType: TextInputType.number,
                maxLength: 16, // Enforce max length input
                decoration: const InputDecoration(
                  labelText: "NIK (KTP)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.credit_card),
                  counterText: "", // Hide default counter
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Harap isi NIK";
                  }
                  if (value.length != 16) {
                    return "NIK harus terdiri dari 16 digit";
                  }
                  return null;
                },
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
        userController.currentUser.value.nama,
        userController.currentUser.value.golDarah,
        tanggal,
      );

      // Add to personal history with details
      userController.addRiwayat(
        tempat: lokasi,
        tanggal: tanggal,
        nik: _nikController.text,
        beratBadan: _beratBadanController.text,
        isSehat: _isSehat,
        tidakMinumObat: _tidakMinumObat,
        tidakHamil: _tidakHamil,
      );

      Navigator.pushNamed(
        context,
        '/daftar_sukses',
        arguments: {'tempat': lokasi, 'tanggal': tanggal, 'jam': jam},
      );
    }
  }
}

class _RequirementItem extends StatelessWidget {
  final String text;
  const _RequirementItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 16,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }
}
