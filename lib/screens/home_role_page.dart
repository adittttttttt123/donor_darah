import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeRolePage extends StatelessWidget {
  const HomeRolePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Text(
                "Pilih Mode Login",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 40),

              // =======================
              // TOMBOL USER
              // =======================
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () {
                  Get.toNamed('/login');  // login user
                },
                child: const Text(
                  "MASUK SEBAGAI USER",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),

              const SizedBox(height: 20),

              // =======================
              // TOMBOL ADMIN
              // =======================
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.redAccent, width: 2),
                  minimumSize: const Size(double.infinity, 55),
                ),
                onPressed: () {
                  Get.toNamed('/admin-login'); // login admin
                },
                child: const Text(
                  "MASUK SEBAGAI ADMIN",
                  style: TextStyle(color: Colors.redAccent, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
