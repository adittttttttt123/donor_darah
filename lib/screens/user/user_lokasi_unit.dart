import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

class UserLokasiUnitScreen extends StatelessWidget {
  const UserLokasiUnitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    final List<Map<String, dynamic>> units = [
      {
        "nama": "PMI Kota Boyolali",
        "alamat": "Jl. Kates No. 10, Pulisen, Boyolali",
        "jarak": "2.5 km",
        "jam": "08:00 - 20:00",
        "lat": -7.531,
        "lng": 110.596,
      },
      {
        "nama": "Unit Transfusi Darah RSUD",
        "alamat": "Jl. Pandan Arang, Boyolali",
        "jarak": "3.2 km",
        "jam": "24 Jam",
        "lat": -7.536,
        "lng": 110.599,
      },
      {
        "nama": "Posko Donor Mojosongo",
        "alamat": "Kecamatan Mojosongo",
        "jarak": "5.0 km",
        "jam": "09:00 - 15:00",
        "lat": -7.540,
        "lng": 110.605,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lokasi Unit Donor"),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Simulated Map Area
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey.shade300,
            child: Stack(
              children: [
                Center(
                  child: Icon(Icons.map, size: 80, color: Colors.grey.shade400),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: FloatingActionButton.small(
                    onPressed: () {},
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.my_location, color: Colors.blue),
                  ),
                ),
                Center(
                  child: Text(
                    "Peta Digital",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: units.length,
              itemBuilder: (context, index) {
                final item = units[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    title: Text(
                      item['nama'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(item['alamat']),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item['jam'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item['jarak'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                    onTap: () {
                      // Navigate or show detail
                    },
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
