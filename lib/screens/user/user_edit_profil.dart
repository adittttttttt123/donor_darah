import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class UserEditProfilScreen extends StatefulWidget {
  const UserEditProfilScreen({super.key});

  @override
  State<UserEditProfilScreen> createState() => _UserEditProfilScreenState();
}

class _UserEditProfilScreenState extends State<UserEditProfilScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk field input
  final _namaController = TextEditingController(text: "Aditya Putra");
  final _golonganController = TextEditingController(text: "A+");
  final _noHpController = TextEditingController(text: "08123456789");
  final _tglLahirController = TextEditingController();
  String _selectedAlamat = "Boyolali";

  // Gambar profil
  Uint8List? _imageBytes;
  String? _imagePath;

  final List<String> _daftarAlamat = [
    "Boyolali",
    "Solo",
    "Klaten",
    "Salatiga",
    "Sragen",
    "Karanganyar",
  ];

  @override
  void initState() {
    super.initState();
    _tglLahirController.text = "20 Juni 2003";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text("Edit Profil"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // FOTO PROFIL
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: _imageBytes != null
                            ? MemoryImage(_imageBytes!)
                            : const NetworkImage(
                                    "https://cdn-icons-png.flaticon.com/512/9131/9131529.png")
                                as ImageProvider,
                      ),
                      IconButton(
                        onPressed: _gantiFotoProfil,
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Nama
                  _buildTextField(
                    controller: _namaController,
                    label: "Nama Lengkap",
                    icon: Icons.person,
                  ),

                  // Golongan Darah
                  _buildTextField(
                    controller: _golonganController,
                    label: "Golongan Darah",
                    icon: Icons.bloodtype,
                  ),

                  // Nomor HP
                  _buildTextField(
                    controller: _noHpController,
                    label: "Nomor HP",
                    icon: Icons.phone_android,
                    keyboardType: TextInputType.phone,
                  ),

                  // Tanggal Lahir
                  GestureDetector(
                    onTap: _pilihTanggalLahir,
                    child: AbsorbPointer(
                      child: _buildTextField(
                        controller: _tglLahirController,
                        label: "Tanggal Lahir",
                        icon: Icons.calendar_month,
                      ),
                    ),
                  ),

                  // Alamat Dropdown
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedAlamat,
                      items: _daftarAlamat
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedAlamat = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Alamat",
                        prefixIcon: const Icon(Icons.location_on,
                            color: Colors.redAccent),
                        filled: true,
                        fillColor: const Color(0xFFF9FAFB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Tombol Simpan
                  FilledButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text("Perubahan profil berhasil disimpan!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text("Simpan Perubahan"),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Tombol Batal
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text("Batal"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.redAccent),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi textfield reusable
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.redAccent),
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? "Harap isi $label" : null,
      ),
    );
  }

  // Date picker
  Future<void> _pilihTanggalLahir() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2003, 6, 20),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme:
                const ColorScheme.light(primary: Colors.redAccent),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        _tglLahirController.text =
            DateFormat('dd MMMM yyyy').format(pickedDate);
      });
    }
  }

  // Ambil foto dari galeri (web)
  Future<void> _gantiFotoProfil() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      final bytes = await file.readAsBytes();
      setState(() {
        _imageBytes = bytes;
         = file.name;
      });
    }
  }
}
