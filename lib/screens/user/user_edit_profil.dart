import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller.dart';

class UserEditProfilScreen extends StatefulWidget {
  const UserEditProfilScreen({super.key});

  @override
  State<UserEditProfilScreen> createState() => _UserEditProfilScreenState();
}

class _UserEditProfilScreenState extends State<UserEditProfilScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _namaController;
  late TextEditingController _noHpController;
  late TextEditingController _tglLahirController;
  late TextEditingController _alamatController;

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

  Uint8List? _imageBytes;
  // ignore: unused_field
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(
      text: _userController.currentUser.value.nama,
    );
    _selectedGolongan = _userController.currentUser.value.golDarah;
    if (!_golonganDarahList.contains(_selectedGolongan)) {
      _selectedGolongan = _golonganDarahList.first;
    }
    _noHpController = TextEditingController(
      text: _userController.currentUser.value.noHp,
    );
    _tglLahirController = TextEditingController(
      text: _userController.currentUser.value.tglLahir,
    );
    _alamatController = TextEditingController(
      text: _userController.currentUser.value.alamat,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Clean White
      appBar: AppBar(
        title: const Text(
          "Edit Profil",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // FOTO PROFIL
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.red.shade100,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: _imageBytes != null
                            ? MemoryImage(_imageBytes!)
                            : const NetworkImage(
                                    "https://cdn-icons-png.flaticon.com/512/9131/9131529.png",
                                  )
                                  as ImageProvider,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: IconButton(
                        onPressed: _gantiFotoProfil,
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 40,
                          minHeight: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              _buildTextField(
                controller: _namaController,
                label: "Nama Lengkap",
                icon: Icons.person_outline_rounded,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedGolongan,
                  items: _golonganDarahList
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _selectedGolongan = value!),
                  decoration: InputDecoration(
                    labelText: "Golongan Darah",
                    prefixIcon: const Icon(
                      Icons.bloodtype_outlined,
                      color: Colors.redAccent,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),

              _buildTextField(
                controller: _noHpController,
                label: "Nomor HP",
                icon: Icons.phone_android_rounded,
                keyboardType: TextInputType.phone,
              ),

              GestureDetector(
                onTap: _pilihTanggalLahir,
                child: AbsorbPointer(
                  child: _buildTextField(
                    controller: _tglLahirController,
                    label: "Tanggal Lahir",
                    icon: Icons.calendar_today_rounded,
                  ),
                ),
              ),

              _buildTextField(
                controller: _alamatController,
                label: "Alamat Lengkap",
                icon: Icons.location_on_outlined,
                keyboardType: TextInputType.streetAddress,
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _userController.updateProfile(
                        newNama: _namaController.text,
                        newGolDarah: _selectedGolongan,
                        newNoHp: _noHpController.text,
                        newTglLahir: _tglLahirController.text,
                        newAlamat: _alamatController.text,
                        newImageBytes: _imageBytes,
                      );

                      if (mounted) {
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      }
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Simpan Perubahan",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
          prefixIcon: Icon(icon, color: Colors.grey.shade400),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? "Harap isi $label" : null,
      ),
    );
  }

  Future<void> _pilihTanggalLahir() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2003, 6, 20),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.redAccent),
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
