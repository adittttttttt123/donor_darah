import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

class UserDetailRiwayatScreen extends StatelessWidget {
  const UserDetailRiwayatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve data from arguments
    final data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (data == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Detail Riwayat")),
        body: const Center(child: Text("Data tidak ditemukan")),
      );
    }

    final String tempat = data['tempat'] ?? '-';
    final String tanggal = data['tgl'] ?? '-';
    // final String jam = data['jam'] ?? '-'; // Data jam belum disimpan di controller, bisa ditambahkan nanti atau ignored
    final String nik = data['nik'] ?? '-';
    final String berat = data['berat'] ?? '-';
    final bool isSehat = (data['is_sehat'] == 'true');
    final bool tidakMinumObat = (data['tidak_obat'] == 'true');
    final bool tidakHamil = (data['tidak_hamil'] == 'true');

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Detail Riwayat Donor"),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Pendaftaran Berhasil",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tanggal,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Location
            _buildSection(
              title: "Lokasi & Waktu",
              children: [
                _buildInfoRow(Icons.place, "Lokasi Unit", tempat),
                const Divider(),
                _buildInfoRow(Icons.calendar_today, "Tanggal Donor", tanggal),
              ],
            ),
            const SizedBox(height: 20),

            // Personal Data
            _buildSection(
              title: "Data Pendonor",
              children: [
                _buildInfoRow(Icons.credit_card, "NIK", nik),
                const Divider(),
                _buildInfoRow(Icons.monitor_weight, "Berat Badan", "$berat kg"),
              ],
            ),
            const SizedBox(height: 20),

            // Health Status
            _buildSection(
              title: "Status Kesehatan",
              children: [
                _buildCheckRow("Merasa Sehat", isSehat),
                const Divider(),
                _buildCheckRow("Tidak Minum Obat (3 hari)", tidakMinumObat),
                const Divider(),
                _buildCheckRow("Tidak Hamil/Menyusui", tidakHamil),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckRow(String label, bool isTrue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            isTrue ? Icons.check_circle : Icons.cancel,
            color: isTrue ? Colors.green : Colors.red,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
