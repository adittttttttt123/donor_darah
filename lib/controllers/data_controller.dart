import 'package:get/get.dart';

class DataController extends GetxController {
  // --- Stok Darah ---
  var stokDarah = <String, int>{
    'A+': 40,
    'A-': 12,
    'B+': 50,
    'B-': 9,
    'AB+': 6,
    'AB-': 2,
    'O+': 82,
    'O-': 18,
  }.obs;

  void updateStok(String gol, int amount) {
    if (stokDarah.containsKey(gol)) {
      stokDarah[gol] = (stokDarah[gol] ?? 0) + amount;
    }
  }

  // --- Data Pendonor ---
  var pendonorList = <Map<String, String>>[
    {'nama': 'Andi Setiawan', 'golongan': 'O+', 'terakhir': '2025-10-12'},
    {'nama': 'Siti Aminah', 'golongan': 'A+', 'terakhir': '2025-09-20'},
    {'nama': 'Budi Santoso', 'golongan': 'B+', 'terakhir': '2025-07-01'},
    {'nama': 'Rina Marlina', 'golongan': 'AB-', 'terakhir': '2025-06-15'},
  ].obs;

  void addPendonor(String nama, String gol, String tanggal) {
    pendonorList.insert(0, {
      'nama': nama,
      'golongan': gol,
      'terakhir': tanggal,
    });
  }

  // --- Jadwal Event ---
  var jadwalList = <Map<String, String>>[
    {'lokasi': 'RSUD Kota', 'tanggal': '2025-11-15', 'jam': '08:00 - 12:00'},
    {'lokasi': 'Kampus ABC', 'tanggal': '2025-11-20', 'jam': '09:00 - 13:00'},
    {'lokasi': 'Mall XYZ', 'tanggal': '2025-12-02', 'jam': '10:00 - 16:00'},
  ].obs;

  void addJadwal(String lokasi, String tanggal, String jam) {
    jadwalList.add({'lokasi': lokasi, 'tanggal': tanggal, 'jam': jam});
  }

  // Computed Properties for Dashboard
  int get totalPendonor => 150 + pendonorList.length; // Mock base + new
  int get pendonorAktif => 120 + (pendonorList.length ~/ 2);
  int get eventAktif => jadwalList.length;
  int get totalStok => stokDarah.values.fold(0, (sum, item) => sum + item);
}
