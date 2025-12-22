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
  Future<void> seedDatabase() async {
    try {
      // 20 Dummy Donors (Keep existing logic or expand if needed, but focus on schedules for now)
      final donors = [
        {'nama': 'Budi Santoso', 'golongan': 'A+', 'terakhir': '2025-01-10'},
        {'nama': 'Siti Aminah', 'golongan': 'B-', 'terakhir': '2025-02-15'},
        {'nama': 'Agus Pratama', 'golongan': 'O+', 'terakhir': '2025-03-20'},
        {'nama': 'Dewi Lestari', 'golongan': 'AB+', 'terakhir': '2025-04-25'},
        {'nama': 'Eko Saputra', 'golongan': 'A-', 'terakhir': '2025-05-30'},
        {'nama': 'Fajar Nugroho', 'golongan': 'B+', 'terakhir': '2025-06-05'},
        {'nama': 'Gita Pertiwi', 'golongan': 'O-', 'terakhir': '2025-07-10'},
        {'nama': 'Hadi Wijaya', 'golongan': 'AB-', 'terakhir': '2025-08-15'},
        {'nama': 'Indah Sari', 'golongan': 'A+', 'terakhir': '2025-09-20'},
        {'nama': 'Joko Susilo', 'golongan': 'B-', 'terakhir': '2025-10-25'},
        {'nama': 'Kartika Putri', 'golongan': 'O+', 'terakhir': '2025-11-30'},
        {'nama': 'Lukman Hakim', 'golongan': 'AB+', 'terakhir': '2025-12-05'},
        {'nama': 'Maya Anggraini', 'golongan': 'A-', 'terakhir': '2025-01-12'},
        {'nama': 'Nina Kurnia', 'golongan': 'B+', 'terakhir': '2025-02-18'},
        {'nama': 'Oscar Pratama', 'golongan': 'O-', 'terakhir': '2025-03-22'},
        {'nama': 'Putri Rahayu', 'golongan': 'AB-', 'terakhir': '2025-04-28'},
        {'nama': 'Rizky Maulana', 'golongan': 'A+', 'terakhir': '2025-05-02'},
        {'nama': 'Sari Wulandari', 'golongan': 'B-', 'terakhir': '2025-06-08'},
        {'nama': 'Tono Sudibyo', 'golongan': 'O+', 'terakhir': '2025-07-12'},
        {'nama': 'Umar Dani', 'golongan': 'AB+', 'terakhir': '2025-08-18'},
      ];

      await _supabase.from('pendonor').insert(donors);

      // GENERATE 50+ DUMMY SCHEDULES
      final locations = [
        'PMI Kota Surakarta',
        'Solo Paragon Mall',
        'Balai Kota Surakarta',
        'Universitas Sebelas Maret (UNS)',
        'The Park Mall Solo Baru',
        'Hartono Mall Solo Baru',
        'RSUD Ir. Soekarno Sukoharjo',
        'UMS (Pabelan)',
        'Alun-Alun Kidul Boyolali',
        'RSUD Pandan Arang Boyolali',
        'Masjid Agung Klaten',
        'Plaza Klaten',
        'RSUP dr. Soeradji Tirtonegoro',
        'Alun-Alun Karanganyar',
        'Palur Plaza',
        'Taman Pancasila Karanganyar',
        'Alun-Alun Sasono Langen Putro Sragen',
        'RSUD dr. Soehadi Prijonegoro Sragen',
        'Pasar Gede Solo',
        'Stasiun Solo Balapan',
      ];

      final schedules = <Map<String, String>>[];
      final now = DateTime.now();

      for (int i = 0; i < 60; i++) {
        final date = now.add(Duration(days: i));
        final dateStr =
            "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

        // Create 1-2 events per day
        final eventsPerDay = (i % 3 == 0) ? 2 : 1;

        for (int j = 0; j < eventsPerDay; j++) {
          final location = locations[(i + j) % locations.length];
          final startHour = 8 + (j * 2); // 08:00, 10:00
          final endHour = startHour + 4; // 12:00, 14:00
          final timeStr =
              "${startHour.toString().padLeft(2, '0')}:00 - ${endHour.toString().padLeft(2, '0')}:00";

          schedules.add({
            'lokasi': location,
            'tanggal': dateStr,
            'jam': timeStr,
          });
        }
      }

      await _supabase.from('jadwal').insert(schedules);

      // Refresh
      fetchData();
      Get.snackbar(
        "Sukses",
        "Berhasil menambahkan ${donors.length} pendonor dan ${schedules.length} jadwal!",
      );
    } catch (e) {
      Get.snackbar("Error", "Gagal menambahkan data dummy: $e");
    }
  }

  // Computed Properties for Dashboard
  int get totalPendonor => pendonorList.length;
  int get pendonorAktif =>
      pendonorList.isNotEmpty ? pendonorList.length - 2 : 0;
  int get eventAktif => jadwalList.length;
  int get totalStok => stokDarah.values.fold(0, (sum, item) => sum + item);
}
