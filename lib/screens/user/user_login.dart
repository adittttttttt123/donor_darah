import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller.dart';
import '../../widgets/loading_overlay.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final emailController = TextEditingController(); // Cleared defaults
  final passwordController = TextEditingController(); // Cleared defaults
  bool isLoading = false;
  int _secretTapCount = 0;

  void _handleSecretTap() {
    _secretTapCount++;
    if (_secretTapCount == 5) {
      _secretTapCount = 0;
      Navigator.pushNamed(context, '/admin_login');
      Get.snackbar(
        "Admin Mode",
        "Secret Access Unlocked 🔓",
        backgroundColor: Colors.black87,
        colorText: Colors.white,
      );
    }
  }

  Future<void> login() async {
    // 1. Validate Form
    if (!_formKey.currentState!.validate()) {
      Get.snackbar(
        "Perhatian",
        "Mohon lengkapi data login Anda",
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFE53935), // Red 600
        colorText: Colors.white,
        borderRadius: 16,
        margin: const EdgeInsets.all(16),
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.white,
          size: 28,
        ),
        duration: const Duration(seconds: 3),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (response.user != null) {
        // Refresh controller data
        if (Get.isRegistered<UserController>()) {
          await Get.find<UserController>().fetchUserProfile();
        } else {
          Get.put(UserController());
        }

        if (mounted) {
          Get.snackbar(
            "Login Berhasil",
            "Selamat datang kembali!",
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xFF43A047), // Green 600
            colorText: Colors.white,
            borderRadius: 16,
            margin: const EdgeInsets.all(16),
            icon: const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 28,
            ),
            duration: const Duration(seconds: 2),
          );
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      }
      // ignore: unused_catch_clause
    } on AuthException catch (e) {
      String errorMessage = "Email atau password salah";
      Color errorColor = const Color(0xFFD32F2F);

      if (e.message.toLowerCase().contains("email not confirmed")) {
        errorMessage = "Email belum dikonfirmasi. Cek inbox Anda.";
        errorColor = Colors.orange.shade800;
      }

      Get.snackbar(
        "Gagal Masuk",
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: errorColor,
        colorText: Colors.white,
        borderRadius: 16,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.error_outline, color: Colors.white, size: 28),
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Silakan coba lagi beberapa saat lagi",
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

  final _formKey = GlobalKey<FormState>(); // Added FormKey

  // Removed _handleDemoLogin to comply with user request
  // Credentials are now just displayed as text.

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ... Logo and Header (preserved structure, shortened for replacement if needed but keeping it safe)
                  // Logo with Secret Gesture
                  GestureDetector(
                    onTap: _handleSecretTap,
                    child: Container(
                      padding: const EdgeInsets.all(40),
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
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  // ignore: deprecated_member_use
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/logo_donor.jpg',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "Selamat Datang",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Silakan masuk untuk melanjutkan",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 48),

                          // Inputs
                          _buildModernTextField(
                            controller: emailController,
                            label: "Email",
                            icon: Icons.email_outlined,
                            validator: (value) => value == null || value.isEmpty
                                ? "Email wajib diisi"
                                : null,
                          ),
                          const SizedBox(height: 16),
                          _buildModernTextField(
                            controller: passwordController,
                            label: "Password",
                            icon: Icons.lock_outline,
                            isPassword: true,
                            validator: (value) => value == null || value.isEmpty
                                ? "Password wajib diisi"
                                : null,
                          ),
                          const SizedBox(height: 12),

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                _showForgotPasswordDialog(context);
                              },
                              child: Text(
                                "Lupa Password?",
                                style: TextStyle(color: Colors.red.shade400),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                                elevation: 8,
                                // ignore: deprecated_member_use
                                shadowColor: Colors.redAccent.withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      "Masuk",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Social Login
                          Row(
                            children: [
                              Expanded(
                                child: Divider(color: Colors.grey.shade200),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  "Atau masuk dengan",
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(color: Colors.grey.shade200),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _socialButton(
                                icon: Icons.g_mobiledata,
                                color: Colors.red,
                                label: "Google",
                                onTap: () {},
                              ),
                              const SizedBox(width: 16),
                              _socialButton(
                                icon: Icons.apple,
                                color: Colors.black,
                                label: "Apple",
                                onTap: () {},
                              ),
                            ],
                          ),

                          // ADMIN SHORTCUT REMOVED
                          // Access via secret tap on logo only
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Belum punya akun? ",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/user_register');
                        },
                        child: const Text(
                          "Daftar",
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
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        // Removed manual border, using TextFormField decoration
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: Icon(icon, color: Colors.grey.shade400),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
          errorBorder: OutlineInputBorder(
            // Red border on error
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final resetEmailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Lupa Kata Sandi"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Masukkan email Anda untuk menerima link reset password.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: resetEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              final email = resetEmailController.text.trim();
              if (email.isEmpty) {
                Get.snackbar(
                  "Peringatan",
                  "Email tidak boleh kosong",
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                );
                return;
              }

              Navigator.pop(context); // Close dialog first

              try {
                await Supabase.instance.client.auth.resetPasswordForEmail(
                  email,
                );
                Get.snackbar(
                  "Sukses",
                  "Link reset password dikirim ke $email",
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                );
              } catch (e) {
                Get.snackbar(
                  "Gagal",
                  "Gagal mengirim link: $e",
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                );
              }
            },
            child: const Text("Kirim", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _socialButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
