import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DataController extends GetxController {
  final _supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    // Delay slightly to ensure GetX context is ready
    Future.delayed(Duration.zero, () => fetchData());
  }

  Future<void> fetchData() async {
    // Fetch Pendonor
    try {
      final donorData = await _supabase
          .from('pendonor')
          .select()
          .order('created_at', ascending: false);

      final safeDonorData = donorData as List<dynamic>? ?? [];

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
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching pendonor: $e");
    }

    // Fetch Jadwal
    try {
      final jadwalData = await _supabase
          .from('jadwal')
          .select()
          .order('created_at', ascending: false);

      final safeJadwalData = jadwalData as List<dynamic>? ?? [];

      jadwalList.assignAll(
        safeJadwalData
            .map<Map<String, String>>(
              (e) => {
                'lokasi': (e['lokasi'] ?? '-').toString(),
                'tanggal': (e['tanggal'] ?? '-').toString(),
                'jam': (e['jam'] ?? '-').toString(),
                'alamat': (e['alamat'] ?? e['lokasi'] ?? '-').toString(),
              },
            )
            .toList(),
      );
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching jadwal: $e");
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

  // --- Seeder ---
  Future<void> seedJadwal() async {
    // List of Map with 'lokasi' and 'alamat'
    final List<Map<String, String>> seedData = [
      {
        'lokasi': 'PMI Kota Surakarta',
        'alamat':
            'Jl. Kolonel Sutarto No.58, Jebres, Kec. Jebres, Kota Surakarta',
      },
      {
        'lokasi': 'Solo Paragon Mall',
        'alamat':
            'Jl. Yosodipuro No.133, Mangkubumen, Kec. Banjarsari, Kota Surakarta',
      },
      {
        'lokasi': 'Balai Kota Surakarta',
        'alamat':
            'Jl. Jend. Sudirman No.2, Kp. Baru, Kec. Ps. Kliwon, Kota Surakarta',
      },
      {
        'lokasi': 'Universitas Sebelas Maret (UNS)',
        'alamat':
            'Jl. Ir. Sutami No.36, Kentingan, Kec. Jebres, Kota Surakarta',
      },
      {
        'lokasi': 'The Park Mall Solo Baru',
        'alamat':
            'Jl. Ir. Soekarno, Dusun II, Madegondo, Kec. Grogol, Kabupaten Sukoharjo',
      },
      {
        'lokasi': 'Hartono Mall Solo Baru',
        'alamat':
            'Jl. Ir. Soekarno, Dusun II, Madegondo, Kec. Grogol, Kabupaten Sukoharjo',
      },
      {
        'lokasi': 'RSUD Ir. Soekarno Sukoharjo',
        'alamat':
            'Jl. Dr. Muwardi No.71, Gayam, Kec. Sukoharjo, Kabupaten Sukoharjo',
      },
      {
        'lokasi': 'UMS (Pabelan)',
        'alamat': 'Jl. A. Yani, Pabelan, Kartasura, Sukoharjo',
      },
      {
        'lokasi': 'Alun-Alun Kidul Boyolali',
        'alamat': 'Kompleks Perkantoran Pemkab Boyolali, Kemiri, Mojosongo',
      },
      {
        'lokasi': 'Pasar Gede Solo',
        'alamat':
            'Jl. Jend. Urip Sumoharjo, Sudiroprajan, Kec. Jebres, Kota Surakarta',
      },
    ];

    try {
      // Check if empty
      if (jadwalList.isNotEmpty) {
        Get.snackbar("Info", "Data jadwal sudah ada, tidak perlu seed.");
        return;
      }

      Get.snackbar(
        "Proses",
        "Sedang mengisi data jadwal asli...",
        duration: const Duration(seconds: 2),
      );

      for (var i = 0; i < seedData.length; i++) {
        // Create random dates for next 30 days
        final now = DateTime.now().add(Duration(days: i % 10));
        final dateStr =
            "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

        await _supabase.from('jadwal').insert({
          'lokasi': seedData[i]['lokasi'],
          'alamat': seedData[i]['alamat'],
          'tanggal': dateStr,
          'jam': '08:00 - 12:00',
        });
      }

      await fetchData();
      Get.snackbar(
        "Sukses",
        "Berhasil menambahkan ${seedData.length} jadwal asli.",
      );
    } catch (e) {
      // ignore: avoid_print
      print("SEEDING ERROR: $e");
      Get.snackbar(
        "Error",
        "Gagal seeding: $e",
        duration: const Duration(seconds: 5),
      );
    }
  }

  // Computed Properties for Dashboard
  int get totalPendonor => pendonorList.length;
  int get pendonorAktif =>
      pendonorList.isNotEmpty ? pendonorList.length - 2 : 0;
  int get eventAktif => jadwalList.length;
}
