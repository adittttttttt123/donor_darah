import 'package:flutter/material.dart';

class DashboardAdminPage extends StatefulWidget {
  const DashboardAdminPage({super.key});

  @override
  State<DashboardAdminPage> createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  // Mock data (ganti dengan fetch dari API / Firebase)
  final Map<String, int> stokDarah = {
    'A+': 40,
    'A-': 12,
    'B+': 50,
    'B-': 9,
    'AB+': 6,
    'AB-': 2,
    'O+': 82,
    'O-': 18,
  };

  final List<Map<String, String>> pendonorTerbaru = [
    {'nama': 'Andi Setiawan', 'golongan': 'O+', 'terakhir': '2025-10-12'},
    {'nama': 'Siti Aminah', 'golongan': 'A+', 'terakhir': '2025-09-20'},
    {'nama': 'Budi Santoso', 'golongan': 'B+', 'terakhir': '2025-07-01'},
    {'nama': 'Rina Marlina', 'golongan': 'AB-', 'terakhir': '2025-06-15'},
  ];

  final List<Map<String, String>> jadwalDonor = [
    {'lokasi': 'RSUD Kota', 'tanggal': '2025-11-15', 'jam': '08:00 - 12:00'},
    {'lokasi': 'Kampus ABC', 'tanggal': '2025-11-20', 'jam': '09:00 - 13:00'},
    {'lokasi': 'Mall XYZ', 'tanggal': '2025-12-02', 'jam': '10:00 - 16:00'},
  ];

  int totalPendonor = 150;
  int pendonorAktif = 120;
  int eventAktif = 3;

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.red.shade50,
              child: Icon(icon, size: 28, color: Colors.red),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 13, color: Colors.black54)),
                const SizedBox(height: 6),
                Text(value,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStokTable() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Stok Darah',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 24,
                columns: const [
                  DataColumn(label: Text('Golongan')),
                  DataColumn(label: Text('Stok (kantong)')),
                  DataColumn(label: Text('Status')),
                ],
                rows: stokDarah.entries.map((e) {
                  final g = e.key;
                  final s = e.value;
                  final status = s >= 50
                      ? 'Aman'
                      : (s >= 15 ? 'Perhatian' : 'Kritis');

                  Color statusColor;
                  if (status == 'Aman') statusColor = Colors.green;
                  else if (status == 'Perhatian') statusColor = Colors.orange;
                  else statusColor = Colors.red;

                  return DataRow(cells: [
                    DataCell(Text(g)),
                    DataCell(Text(s.toString())),
                    DataCell(Row(
                      children: [
                        Icon(Icons.circle, size: 12, color: statusColor),
                        const SizedBox(width: 8),
                        Text(status),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendonorList() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pendonor Terbaru',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...pendonorTerbaru.map((p) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(child: Text(p['nama']![0])),
                title: Text(p['nama']!),
                subtitle: Text('Gol: ${p['golongan']} — Terakhir: ${p['terakhir']}'),
                trailing: TextButton(
                  onPressed: () {
                    // detail pendonor
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(p['nama']!),
                        content: Text('Detail pendonor (mock).'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Tutup'),
                          )
                        ],
                      ),
                    );
                  },
                  child: const Text('Detail'),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildJadwalList() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Jadwal Donor Terdekat',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...jadwalDonor.map((j) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(j['lokasi']!),
                subtitle: Text('${j['tanggal']} • ${j['jam']}'),
                trailing: ElevatedButton(
                  onPressed: () {
                    // contoh edit / detail
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Kelola jadwal: ${j['lokasi']}')),
                    );
                  },
                  child: const Text('Kelola'),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 220,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const SizedBox(height: 6),
          const Text('Donor Darah',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 18),
          _sidebarItem(Icons.dashboard, 'Dashboard', onTap: () {}),
          _sidebarItem(Icons.people, 'Data Pendonor', onTap: () {}),
          _sidebarItem(Icons.inventory_2, 'Stok Darah', onTap: () {}),
          _sidebarItem(Icons.event, 'Jadwal Donor', onTap: () {}),
          const Spacer(),
          const Divider(),
          TextButton.icon(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(title),
      onTap: onTap,
      dense: true,
      visualDensity: const VisualDensity(vertical: -3),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin Donor Darah'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none),
                ),
                const SizedBox(width: 6),
                CircleAvatar(child: Text('A')),
                const SizedBox(width: 12),
              ],
            ),
          )
        ],
      ),
      drawer: isDesktop ? null : Drawer(child: _buildSidebar()),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sidebar
                  _buildSidebar(),
                  const SizedBox(width: 16),
                  // Main content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Statistics row
                          Row(
                            children: [
                              Expanded(
                                  child: _buildStatCard(
                                      'Total Pendonor', '$totalPendonor', Icons.people)),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: _buildStatCard('Pendonor Aktif', '$pendonorAktif',
                                      Icons.bloodtype)),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: _buildStatCard(
                                      'Event Aktif', '$eventAktif', Icons.event)),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: _buildStatCard('Stok Total',
                                      '${stokDarah.values.reduce((a, b) => a + b)}', Icons.storage)),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Grid: left stok + jadwal (two column)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    _buildStokTable(),
                                    const SizedBox(height: 12),
                                    _buildJadwalList(),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    _buildPendonorList(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : // Mobile layout: single column
            SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: _buildStatCard(
                                'Total Pendonor', '$totalPendonor', Icons.people)),
                        const SizedBox(width: 8),
                        Expanded(
                            child: _buildStatCard(
                                'Pendonor Aktif', '$pendonorAktif', Icons.bloodtype)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildStokTable(),
                    const SizedBox(height: 12),
                    _buildPendonorList(),
                    const SizedBox(height: 12),
                    _buildJadwalList(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
      ),
    );
  }
}
