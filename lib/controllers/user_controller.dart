import 'dart:typed_data';
import 'package:get/get.dart';

class UserController extends GetxController {
  var nama = "Aditya Putra".obs;
  var golDarah = "A+".obs;
  var noHp = "08123456789".obs;
  var tglLahir = "20 Juni 2003".obs;
  var alamat = "Boyolali".obs;
  var profileImage =
      "https://cdn-icons-png.flaticon.com/512/9131/9131529.png".obs;
  var profileImageBytes = Rx<Uint8List?>(null);

  void updateProfile({
    required String newNama,
    required String newGolDarah,
    required String newNoHp,
    required String newTglLahir,
    required String newAlamat,
    Uint8List? newImageBytes,
  }) {
    nama.value = newNama;
    golDarah.value = newGolDarah;
    noHp.value = newNoHp;
    tglLahir.value = newTglLahir;
    alamat.value = newAlamat;
    if (newImageBytes != null) {
      profileImageBytes.value = newImageBytes;
    }
  }
}
