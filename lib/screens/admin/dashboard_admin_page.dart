import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_theme.dart';
import '../../widgets/stat_card.dart';
import '../../controllers/data_controller.dart';

class DashboardAdminPage extends StatefulWidget {
  const DashboardAdminPage({super.key});

  @override
  State<DashboardAdminPage> createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  final DataController controller = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Generate Data Dummy"),
                  content: const Text(
                    "Apakah Anda yakin ingin mengisi database dengan data dummy? Ini akan menambahkan 20 pendonor dan 10 jadwal.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Batal"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        controller.seedDatabase();
                      },
                      child: const Text("Ya, Isi Data"),
                    ),
                  ],
                ),
              );
            },
            tooltip: "Isi Data Dummy",
            icon: const Icon(Icons.storage, color: Colors.blue),
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            backgroundColor: Colors.white24,
            child: Text('A', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: isDesktop ? null : Drawer(child: _buildSidebar(context)),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop) _buildSidebar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Overview",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStatsGrid(width),
                  const SizedBox(height: 24),
                  if (width > 1200)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: _buildStokTable()),
                        const SizedBox(width: 24),
                        Expanded(flex: 1, child: _buildPendonorList()),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _buildStokTable(),
                        const SizedBox(height: 24),
                        _buildPendonorList(),
                      ],
                    ),
                  const SizedBox(height: 24),
                  _buildJadwalList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    var currentRoute = ModalRoute.of(context)?.settings.name;
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.centerLeft,
            // ignore: deprecated_member_use
            color: AppTheme.primaryColor.withOpacity(0.05),
            child: Row(
              children: [
                Icon(Icons.bloodtype, color: AppTheme.primaryColor, size: 32),
                const SizedBox(width: 12),
                const Text(
                  'Donor Darah',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _sidebarItem(
            Icons.dashboard,
            'Dashboard',
            isActive: currentRoute == '/admin/dashboard',
            onTap: () =>
                Navigator.pushReplacementNamed(context, '/admin/dashboard'),
          ),
          _sidebarItem(
            Icons.people,
            'Data Pendonor',
            isActive: currentRoute == '/admin/pendonor',
            onTap: () => Navigator.pushNamed(context, '/admin/pendonor'),
          ),
          _sidebarItem(
            Icons.inventory_2,
            'Stok Darah',
            isActive: currentRoute == '/admin/stok',
            onTap: () => Navigator.pushNamed(context, '/admin/stok'),
          ),
          _sidebarItem(
            Icons.event,
            'Jadwal Donor',
            isActive: currentRoute == '/admin/jadwal',
            onTap: () => Navigator.pushNamed(context, '/admin/jadwal'),
          ),
          const Spacer(),
          const Divider(),
          _sidebarItem(
            Icons.logout,
            'Logout',
            color: Colors.red,
            onTap: () =>
                Navigator.pushReplacementNamed(context, '/admin_login'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _sidebarItem(
    IconData icon,
    String title, {
    bool isActive = false,
    Color? color,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? (isActive ? AppTheme.primaryColor : Colors.grey),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? (isActive ? AppTheme.primaryColor : Colors.grey[700]),
          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      selected: isActive,
      // ignore: deprecated_member_use
      selectedTileColor: AppTheme.primaryColor.withOpacity(0.05),
      dense: true,
      onTap: onTap,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(30)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }

  Widget _buildStatsGrid(double screenWidth) {
    int crossAxisCount = screenWidth > 1100 ? 4 : (screenWidth > 600 ? 2 : 1);

    return Obx(
      () => GridView.count(
        crossAxisCount: crossAxisCount,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5, // Make cards shorter
        children: [
          StatCard(
            title: 'Total Pendonor',
            value: controller.totalPendonor.toString(),
            icon: Icons.people,
          ),
          StatCard(
            title: 'Pendonor Aktif',
            value: controller.pendonorAktif.toString(),
            icon: Icons.favorite,
            color: Colors.pink,
          ),
          StatCard(
            title: 'Event Bulan Ini',
            value: controller.eventAktif.toString(),
            icon: Icons.calendar_today,
            color: Colors.orange,
          ),
          StatCard(
            title: 'Total Stok (Kantong)',
            value: controller.totalStok.toString(),
            icon: Icons.local_hospital,
            color: Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildStokTable() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildSectionHeader(
              'Monitoring Stok Darah',
              Icons.inventory,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(
                () => DataTable(
                  headingRowHeight: 40,
                  dataRowMinHeight: 40,
                  dataRowMaxHeight: 52,
                  columns: const [
                    DataColumn(label: Text('Golongan Darah')),
                    DataColumn(label: Text('Jumlah Stok')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: controller.stokDarah.entries.map((e) {
                    final status = e.value >= 20
                        ? 'Aman'
                        : (e.value >= 10 ? 'Menipis' : 'Kritis');
                    final color = e.value >= 20
                        ? Colors.green
                        : (e.value >= 10 ? Colors.orange : Colors.red);

                    return DataRow(
                      cells: [
                        DataCell(
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              e.key,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            '${e.value} Kantong',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.circle, size: 10, color: color),
                              const SizedBox(width: 6),
                              Text(
                                status,
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendonorList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionHeader('Pendonor Terbaru', Icons.history),
                  TextButton(
                    onPressed: () {},
                    child: const Text("Lihat Semua"),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Obx(
              () => ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.pendonorList.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, indent: 16),
                itemBuilder: (context, index) {
                  final item = controller.pendonorList[index];
                  return ListTile(
                    leading: CircleAvatar(
                      // ignore: deprecated_member_use
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      child: Text(
                        item['nama']![0],
                        style: const TextStyle(color: AppTheme.primaryColor),
                      ),
                    ),
                    title: Text(
                      item['nama']!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text("${item['golongan']} • ${item['terakhir']}"),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey,
                    ),
                    onTap: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJadwalList() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildSectionHeader(
              'Jadwal Kegiatan',
              Icons.event_available,
            ),
          ),
          const Divider(height: 1),
          Obx(
            () => Column(
              children: controller.jadwalList.map((j) {
                return ListTile(
                  leading: divContainer(
                    child: const Icon(
                      Icons.calendar_month,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  title: Text(
                    j['lokasi']!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("${j['tanggal']} • ${j['jam']}"),
                  trailing: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text("Atur"),
                    style: ElevatedButton.styleFrom(
                      // ignore: deprecated_member_use
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      foregroundColor: AppTheme.primaryColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget divContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}
