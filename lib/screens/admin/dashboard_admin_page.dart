import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_theme.dart';
import '../../controllers/data_controller.dart';
import 'dashboard_overview_page.dart';
import 'data_pendonor_page.dart';
import 'stok_darah_page.dart';
import 'jadwal_donor_page.dart';

class DashboardAdminPage extends StatefulWidget {
  const DashboardAdminPage({super.key});

  @override
  State<DashboardAdminPage> createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  int _selectedIndex = 0;
  // Assuming DataController is defined elsewhere and available via Get.find
  final DataController controller = Get.find<DataController>();

  final List<Widget> _pages = [
    const DashboardOverviewPage(),
    const DataPendonorPage(),
    const StokDarahPage(),
    const JadwalDonorPage(),
  ];

  final List<String> _titles = [
    "Dashboard Admin",
    "Data Pendonor",
    "Stok Darah",
    "Jadwal Donor",
  ];

  void _showSeedDialog(BuildContext context) {
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
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 900;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          const SizedBox(width: 8),
          if (_selectedIndex == 0) // Only show seed on Dashboard
            IconButton(
              onPressed: () => _showSeedDialog(context),
              tooltip: "Isi Data Dummy",
              icon: const Icon(Icons.storage, color: Colors.white),
            ),
          const SizedBox(width: 8),
          const CircleAvatar(
            backgroundColor: Colors.white24,
            child: Text('A', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      // Drawer is available for Mobile (opened by AppBar leading)
      drawer: isDesktop ? null : Drawer(child: _buildSidebar(context)),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar for Desktop
          if (isDesktop) _buildSidebar(context),

          // Main Content
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
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
          _sidebarItem(0, Icons.dashboard, 'Dashboard'),
          _sidebarItem(1, Icons.people, 'Data Pendonor'),
          _sidebarItem(2, Icons.inventory_2, 'Stok Darah'),
          _sidebarItem(3, Icons.event, 'Jadwal Donor'),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
            dense: true,
            onTap: () =>
                Navigator.pushReplacementNamed(context, '/admin_login'),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 4,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _sidebarItem(int index, IconData icon, String title) {
    final isActive = _selectedIndex == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? AppTheme.primaryColor : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? AppTheme.primaryColor : Colors.grey[700],
          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      selected: isActive,
      // ignore: deprecated_member_use
      selectedTileColor: AppTheme.primaryColor.withOpacity(0.05),
      dense: true,
      onTap: () {
        setState(() => _selectedIndex = index);
        // If mobile (drawer is open), close it
        if (Scaffold.of(context).hasDrawer &&
            Scaffold.of(context).isDrawerOpen) {
          Navigator.pop(context);
        } else {
          // On mobile, the Sidebar is inside a Drawer, so accessing this context might trigger the parent scaffold.
          // However, if we are in desktop, hasDrawer is false (null).
          // If we are in Drawer, we should pop.
          final width = MediaQuery.sizeOf(context).width;
          if (width < 900) {
            Navigator.pop(context);
          }
        }
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(30)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}
