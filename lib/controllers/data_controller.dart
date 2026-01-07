import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DataController extends GetxController {
  final _supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    // Delay slightly to ensure GetX context is ready if snackbar is needed
    Future.delayed(Duration.zero, () => fetchData());
  }

  Future<void> fetchData() async {
    try {
      // Fetch Stok
      final stokData = await _supabase.from('stok_darah').select();
      final newStok = <String, int>{};
      final safeStokData = stokData as List<dynamic>? ?? []; // Safety check

      for (var item in safeStokData) {
        if (item != null && item['golongan'] != null && item['stok'] != null) {
          newStok[item['golongan'].toString()] =
              int.tryParse(item['stok'].toString()) ?? 0;
        }
      }
      stokDarah.assignAll(newStok);

      // Fetch Pendonor
      final donorData = await _supabase
          .from('pendonor')
          .select()
          .order('created_at', ascending: false);

      final safeDonorData = donorData as List<dynamic>? ?? []; // Safety check

      pendonorList.assignAll(
        safeDonorData
            .map<Map<String, String>>(
              (e) => {
                'nama': (e['nama'] ?? '-').toString(),
                'golongan': (e['golongan'] ?? '-').toString(),
                'terakhir': (e['terakhir'] ?? '-').toString(),
              },
            )
            .toList(),
      );

      // Fetch Jadwal
      final jadwalData = await _supabase
          .from('jadwal')
          .select()
          .order('created_at', ascending: false);

      final safeJadwalData = jadwalData as List<dynamic>? ?? []; // Safety check

      jadwalList.assignAll(
        safeJadwalData
            .map<Map<String, String>>(
              (e) => {
                'lokasi': (e['lokasi'] ?? '-').toString(),
                'tanggal': (e['tanggal'] ?? '-').toString(),
                'jam': (e['jam'] ?? '-').toString(),
              },
            )
            .toList(),
      );
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data: $e");
    }
  }

  // --- Stok Darah ---
  var stokDarah = <String, int>{}.obs;

  Future<void> updateStok(String gol, int amount) async {
    if (stokDarah.containsKey(gol)) {
      final current = stokDarah[gol] ?? 0;
      final newValue = current + amount;

      // Optimistic Update
      stokDarah[gol] = newValue;

      try {
        await _supabase.from('stok_darah').upsert({
          'golongan': gol,
          'stok': newValue,
        });
      } catch (e) {
        // Revert on error
        stokDarah[gol] = current;
        Get.snackbar("Error", "Gagal update stok");
      }
    }
  }

  // --- Data Pendonor ---
  var pendonorList = <Map<String, String>>[].obs;

  Future<void> addPendonor(String nama, String gol, String tanggal) async {
    try {
      await _supabase.from('pendonor').insert({
        'nama': nama,
        'golongan': gol,
        'terakhir': tanggal,
      });
      // Refresh list
      fetchData();
    } catch (e) {
      Get.snackbar("Error", "Gagal menambah pendonor");
    }
  }

  // --- Jadwal Event ---
  var jadwalList = <Map<String, String>>[].obs;

  Future<void> addJadwal(String lokasi, String tanggal, String jam) async {
    try {
      await _supabase.from('jadwal').insert({
        'lokasi': lokasi,
        'tanggal': tanggal,
        'jam': jam,
      });
      fetchData();
    } catch (e) {
      Get.snackbar("Error", "Gagal menambah jadwal");
    }
  }

  // Computed Properties for Dashboard

  // Computed Properties for Dashboard
  int get totalPendonor => pendonorList.length;
  int get pendonorAktif =>
      pendonorList.isNotEmpty ? pendonorList.length - 2 : 0;
  int get eventAktif => jadwalList.length;
  int get totalStok => stokDarah.values.fold(0, (sum, item) => sum + item);
}
