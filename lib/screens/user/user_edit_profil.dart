import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller.dart';
import '../../core/app_theme.dart';

class UserEditProfilScreen extends StatefulWidget {
  const UserEditProfilScreen({super.key});

  @override
  State<UserEditProfilScreen> createState() => _UserEditProfilScreenState();
}

class _UserEditProfilScreenState extends State<UserEditProfilScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk field input
  late TextEditingController _namaController;
  late TextEditingController _noHpController;
  late TextEditingController _tglLahirController;
  late TextEditingController _alamatController; // New controller

  String _selectedGolongan = "A+";
  final List<String> _golonganDarahList = [
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
    "O+",
    "O-",
  ];

  final UserController _userController = Get.find<UserController>();

  // Gambar profil
  Uint8List? _imageBytes;
  // ignore: unused_field
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: _userController.nama.value);
    _selectedGolongan = _userController.golDarah.value;
    // Validate if initial value is in list
    if (!_golonganDarahList.contains(_selectedGolongan)) {
      _selectedGolongan = _golonganDarahList.first;
    }
    _noHpController = TextEditingController(text: _userController.noHp.value);
    _tglLahirController = TextEditingController(
      text: _userController.tglLahir.value,
    );
    _alamatController = TextEditingController(
      text: _userController.alamat.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text("Edit Profil"),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
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
                  // ignore: deprecated_member_use
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
                                    "https://cdn-icons-png.flaticon.com/512/9131/9131529.png",
                                  )
                                  as ImageProvider,
                      ),
                      IconButton(
                        onPressed: _gantiFotoProfil,
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
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

                  // Golongan Darah Dropdown
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: DropdownButtonFormField<String>(
                      value: _selectedGolongan,
                      items: _golonganDarahList
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedGolongan = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Golongan Darah",
                        prefixIcon: const Icon(
                          Icons.bloodtype,
                          color: AppTheme.primaryColor,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF9FAFB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
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

                  // Alamat TextField (Free Text)
                  _buildTextField(
                    controller: _alamatController,
                    label: "Alamat Lengkap",
                    icon: Icons.location_on,
                    keyboardType: TextInputType.streetAddress,
                  ),

                  const SizedBox(height: 25),

                  // Tombol Simpan
                  FilledButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _userController.updateProfile(
                          newNama: _namaController.text,
                          newGolDarah: _selectedGolongan,
                          newNoHp: _noHpController.text,
                          newTglLahir: _tglLahirController.text,
                          newAlamat: _alamatController.text,
                          newImageBytes: _imageBytes,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Perubahan profil berhasil disimpan!",
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text("Simpan Perubahan"),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
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
                      foregroundColor: AppTheme.primaryColor,
                      side: const BorderSide(color: AppTheme.primaryColor),
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
          prefixIcon: Icon(icon, color: AppTheme.primaryColor),
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.primaryColor),
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
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        _tglLahirController.text = DateFormat(
          'dd MMMM yyyy',
        ).format(pickedDate);
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
        _imagePath = file.name;
      });
    }
  }
}
