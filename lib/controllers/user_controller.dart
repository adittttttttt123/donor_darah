import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserController extends GetxController {
  // Observables with empty defaults (no dummy data)
  var nama = "".obs;
  var golDarah = "-".obs;
  var noHp = "".obs;
  var tglLahir = "-".obs;
  var alamat = "-".obs;
  var email = "".obs; // Added email
  var profileImage =
      "https://cdn-icons-png.flaticon.com/512/9131/9131529.png".obs;
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
      email.value = user.email ?? "";
      try {
        final data = await Supabase.instance.client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle();

        if (data != null) {
          nama.value = data['nama'] ?? "";
          golDarah.value = data['gol_darah'] ?? "-";
          noHp.value = data['no_hp'] ?? "";
          tglLahir.value = data['tgl_lahir'] ?? "-";
          alamat.value = data['alamat'] ?? "-";
          // If we had an image url column, we would set it here
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
    nama.value = newNama;
    golDarah.value = newGolDarah;
    noHp.value = newNoHp;
    tglLahir.value = newTglLahir;
    alamat.value = newAlamat;
    if (newImageBytes != null) {
      profileImageBytes.value = newImageBytes;
    }

    // 2. Persist to Supabase
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        await Supabase.instance.client.from('profiles').upsert({
          'id': user.id,
          'nama': newNama,
          'gol_darah': newGolDarah,
          'no_hp': newNoHp,
          'tgl_lahir': newTglLahir,
          'alamat': newAlamat,
          'email': user.email, // Ensure email is kept
        });
        Get.snackbar("Sukses", "Profil berhasil diperbarui");
      } catch (e) {
        Get.snackbar("Error", "Gagal menyimpan profil: $e");
      }
    }
  }

  void clearData() {
    nama.value = "";
    golDarah.value = "-";
    noHp.value = "";
    tglLahir.value = "-";
    alamat.value = "-";
    email.value = "";
    riwayatDonor.clear();
  }

  void addRiwayat(String tempat, String tanggal) {
    riwayatDonor.add({'tempat': tempat, 'tgl': tanggal});
    riwayatDonor.refresh();
  }
}
