import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

class UserJadwalScreen extends StatefulWidget {
  const UserJadwalScreen({super.key});

  @override
  State<UserJadwalScreen> createState() => _UserJadwalScreenState();
}

class _UserJadwalScreenState extends State<UserJadwalScreen> {
  // FINAL LIST OF LOCATIONS (SOLO RAYA)
  final List<String> _locations = [
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

  final List<Map<String, String>> _jadwalList = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _generateDummyData();
  }

  void _generateDummyData() {
    final now = DateTime.now();
    for (int i = 0; i < 60; i++) {
      final date = now.add(Duration(days: i));
      final dateStr =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      // Create 1-2 events per day
      final eventsPerDay = (i % 3 == 0) ? 2 : 1;

      for (int j = 0; j < eventsPerDay; j++) {
        final locationIndex = (i + j) % _locations.length;
        final location = _locations[locationIndex];

        final startHour = 8 + (j * 2); // 08:00, 10:00
        final endHour = startHour + 4; // 12:00, 14:00
        final timeStr =
            "${startHour.toString().padLeft(2, '0')}:00 - ${endHour.toString().padLeft(2, '0')}:00";

        _jadwalList.add({
          'lokasi': location,
          'tanggal': dateStr,
          'jam': timeStr,
        });
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Filter logic
    final filteredJadwal = _searchQuery.isEmpty
        ? _jadwalList
        : _jadwalList.where((item) {
            final tempat = (item["lokasi"] ?? "").toLowerCase();
            final tanggal = (item["tanggal"] ?? "").toLowerCase();
            return tempat.contains(_searchQuery.toLowerCase()) ||
                tanggal.contains(_searchQuery.toLowerCase());
          }).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Jadwal Donor"),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: "Cari lokasi atau tanggal...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: AppTheme.primaryColor),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredJadwal.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Lokasi tidak ditemukan",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: filteredJadwal.length,
                    itemBuilder: (context, index) {
                      final item = filteredJadwal[index];
                      final tempat = item['lokasi'] ?? "-";
                      final alamat = item['lokasi'] ?? "-";
                      final tanggal = item['tanggal'] ?? "-";
                      final jam = item['jam'] ?? "-";

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.local_hospital,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tempat,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              size: 14,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                alamat,
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 13,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.access_time,
                                              size: 14,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              "$tanggal • $jam",
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/daftar_donor',
                                      arguments: item,
                                    );
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text("Daftar Donor"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
