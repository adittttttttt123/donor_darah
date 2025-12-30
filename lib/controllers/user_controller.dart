// ignore: unnecessary_import
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  // Use UserModel for state
  final Rx<UserModel> currentUser = UserModel.empty().obs;

  // Keep these separate as they are UI state not persisted in user profile usually,
  // or maybe profileImageBytes is temp?
  // Let's keep profileImage as standard string in UserModel, but bytes here for upload preview?
  var profileImageBytes = Rx<Uint8List?>(null);

  var riwayatDonor = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        final data = await Supabase.instance.client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle();

        if (data != null) {
          currentUser.value = UserModel.fromJson(data);
        } else {
          // If profile doesn't exist, maybe create one or unset?
          // Setting partial data from Auth
          currentUser.value = UserModel(
            id: user.id,
            nama: user.userMetadata?['nama'] ?? '',
            email: user.email ?? '',
            noHp: user.userMetadata?['no_hp'] ?? '',
          );
        }
      } catch (e) {
        // ignore: avoid_print
        print("Error fetching profile: $e");
      }
    }
  }

  Future<void> updateProfile({
    required String newNama,
    required String newGolDarah,
    required String newNoHp,
    required String newTglLahir,
    required String newAlamat,
    Uint8List? newImageBytes,
  }) async {
    // 1. Update Local State
    final oldUser = currentUser.value;
    var newUser = oldUser.copyWith(
      nama: newNama,
      golDarah: newGolDarah,
      noHp: newNoHp,
      tglLahir: newTglLahir,
      alamat: newAlamat,
    );
    currentUser.value = newUser;

    if (newImageBytes != null) {
      profileImageBytes.value = newImageBytes;
      try {
        final String path = '${newUser.id}/profile.jpg';
        await Supabase.instance.client.storage
            .from(
              'profile_pictures',
            ) // Ensure this bucket exists in your Supabase project
            .uploadBinary(
              path,
              newImageBytes,
              fileOptions: const FileOptions(
                upsert: true,
                contentType: 'image/jpeg',
              ),
            );
        final String imageUrl = Supabase.instance.client.storage
            .from('profile_pictures')
            .getPublicUrl(path);

        // Append timestamp to avoid caching issues
        final String finalUrl =
            '$imageUrl?t=${DateTime.now().millisecondsSinceEpoch}';

        newUser = newUser.copyWith(profileImage: finalUrl);
        currentUser.value = newUser;
      } catch (e) {
        // ignore: avoid_print
        print("Error uploading image: $e");
        Get.snackbar("Warning", "Gagal mengupload gambar: $e");
      }
    }

    // 2. Persist to Supabase
    try {
      await Supabase.instance.client.from('profiles').upsert(newUser.toJson());
      Get.snackbar("Sukses", "Profil berhasil diperbarui");
    } catch (e) {
      Get.snackbar("Error", "Gagal menyimpan profil: $e");
    }
  }

  void clearData() {
    currentUser.value = UserModel.empty();
    profileImageBytes.value = null;
    riwayatDonor.clear();
  }

  void addRiwayat({
    required String tempat,
    required String tanggal,
    required String nik,
    required String beratBadan,
    required bool isSehat,
    required bool tidakMinumObat,
    required bool tidakHamil,
  }) {
    riwayatDonor.add({
      'tempat': tempat,
      'tgl': tanggal,
      'nik': nik,
      'berat': beratBadan,
      'is_sehat': isSehat.toString(),
      'tidak_obat': tidakMinumObat.toString(),
      'tidak_hamil': tidakHamil.toString(),
    });
    riwayatDonor.refresh();
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      final response = await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      if (response.user != null) {
        Get.snackbar(
          "Berhasil",
          "Password berhasil diubah",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Gagal",
        "Gagal mengubah password: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ignore: unused_element
  Future<void> _handlePostLogin(User? user) async {
    if (user != null) {
      await fetchUserProfile();

      // If profile is empty (new user via social login), insert it
      if (currentUser.value.id.isEmpty || currentUser.value.nama.isEmpty) {
        final newProfile = UserModel(
          id: user.id,
          nama:
              user.userMetadata?['full_name'] ??
              user.userMetadata?['name'] ??
              user.email?.split('@')[0] ??
              'User',
          email: user.email ?? '',
          noHp: '',
          // profileImage: user.userMetadata?['avatar_url'] ?? user.userMetadata?['picture'] ?? '',
          // We can add profile image if supported by model, model has profileImage
        );

        // Try to save this initial profile
        try {
          // Check if it really exists first? fetchUserProfile handles checking.
          // If fetchUserProfile failed to find data, it sets local data but id might be set.
          // Let's force upsert if we think it's new.

          // A better check:
          final existing = await Supabase.instance.client
              .from('profiles')
              .select()
              .eq('id', user.id)
              .maybeSingle();
          if (existing == null) {
            await Supabase.instance.client.from('profiles').insert({
              'id': newProfile.id,
              'nama': newProfile.nama,
              'email': newProfile.email,
              'no_hp': '', // Social login usually doesn't provide phone
            });
            // Refresh local data
            await fetchUserProfile();
          }
        } catch (e) {
          debugPrint("Error creating new social user profile: $e");
        }
      }
    }
  }
}
