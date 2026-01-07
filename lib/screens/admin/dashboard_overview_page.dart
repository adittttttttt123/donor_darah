import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_theme.dart';
import '../../widgets/stat_card.dart';
import '../../controllers/data_controller.dart';

class DashboardOverviewPage extends StatelessWidget {
  const DashboardOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    // We assume the controller is already put in LoginAdminPage
    final DataController controller = Get.find<DataController>();
    final width = MediaQuery.sizeOf(context).width;

    return SingleChildScrollView(
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
          _buildStatsGrid(width, controller),
          const SizedBox(height: 24),
          if (width > 1200)
            _buildPendonorList(controller)
          else
            _buildPendonorList(controller),
          const SizedBox(height: 24),
          _buildJadwalList(controller),
        ],
      ),
    );
  }

  // _showSeedDialog logic moved to DashboardAdminPage or accessible via callback?
  // For now I will leave the method here unused or remove it if I move it.
  // I will remove it to clean up.

  Widget _buildStatsGrid(double screenWidth, DataController controller) {
    int crossAxisCount = screenWidth > 1100 ? 3 : (screenWidth > 600 ? 2 : 1);

    return Obx(
      () => GridView.count(
        crossAxisCount: crossAxisCount,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
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
          // Total Stok Removed
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

  // _buildStokTable Removed

  Widget _buildPendonorList(DataController controller) {
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

  Widget _buildJadwalList(DataController controller) {
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
