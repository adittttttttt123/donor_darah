import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

import '../../widgets/loading_overlay.dart';

class UserRegisterScreen extends StatefulWidget {
  const UserRegisterScreen({super.key});

  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) {
      Get.snackbar(
        "Perhatian",
        "Mohon lengkapi semua data yang diperlukan",
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFFF5252),
        colorText: Colors.white,
        borderRadius: 20,
        margin: const EdgeInsets.all(20),
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.white,
          size: 28,
        ),
        shouldIconPulse: true,
        barBlur: 20,
        isDismissible: true,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // 1. Sign Up with Metadata
      final response = await Supabase.instance.client.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        data: {
          'nama': nameController.text.trim(),
          'no_hp': phoneController.text.trim(),
        },
      );

      // 2. Insert Profile (if signup successful and we have a user ID)
      if (response.user != null) {
        // Attempt to insert into profiles table
        // This relies on RLS allowing insert, or the session being active.
        // If email confirmation is enabled, the session might be null.
        if (response.session != null) {
          try {
            await Supabase.instance.client.from('profiles').insert({
              'id': response.user!.id,
              'nama': nameController.text.trim(),
              'email': emailController.text.trim(),
              'no_hp': phoneController.text.trim(),
            });
          } catch (e) {
            // If profile insert fails, we log it but don't block registration
            // because we have metadata as fallback
            debugPrint("Profile insert failed: $e");
          }
        }

        if (mounted) {
          Get.snackbar(
            "Registrasi Berhasil",
            "Akun Anda telah berhasil dibuat! Silakan Login.",
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xFF4CAF50), // Green 500
            colorText: Colors.white,
            borderRadius: 20,
            margin: const EdgeInsets.all(20),
            icon: const Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.white,
              size: 28,
            ),
            shouldIconPulse: true,
            barBlur: 20,
            duration: const Duration(seconds: 4),
          );
          Navigator.pushReplacementNamed(context, '/'); // Go to Login
        }
      }
    } on AuthException catch (e) {
      Get.snackbar(
        "Gagal Registrasi",
        e.message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
        borderRadius: 20,
        margin: const EdgeInsets.all(20),
        icon: const Icon(
          Icons.error_outline_rounded,
          color: Colors.white,
          size: 28,
        ),
        barBlur: 20,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Gagal registrasi: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
        borderRadius: 20,
        margin: const EdgeInsets.all(20),
        icon: const Icon(
          Icons.error_outline_rounded,
          color: Colors.white,
          size: 28,
        ),
        barBlur: 20,
        duration: const Duration(seconds: 4),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Card(
                elevation: 4,
                // ignore: deprecated_member_use
                shadowColor: Colors.redAccent.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/logo_donor.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.grey,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Buat Akun Baru",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Silakan lengkapi data diri Anda",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 32),

                      _buildTextField(
                        controller: nameController,
                        label: "Nama Lengkap",
                        icon: Icons.person_outline,
                        validator: (v) =>
                            v!.isEmpty ? "Nama wajib diisi" : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: emailController,
                        label: "Email",
                        icon: Icons.email_outlined,
                        inputType: TextInputType.emailAddress,
                        validator: (v) =>
                            v!.isEmpty ? "Email wajib diisi" : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: phoneController,
                        label: "No. Handphone",
                        icon: Icons.phone_android,
                        inputType: TextInputType.phone,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "No. HP wajib diisi";
                          }
                          if (v.length != 12) {
                            return "No. HP harus terdiri dari 12 digit";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: passwordController,
                        label: "Password",
                        icon: Icons.lock_outline,
                        isPassword: true,
                        validator: (v) =>
                            v!.isEmpty ? "Password wajib diisi" : null,
                      ),
                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Daftar Sekarang",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Sudah punya akun? ",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Masuk",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: inputType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 22, color: Colors.grey.shade400),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
