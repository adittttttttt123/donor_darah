import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller.dart';
import '../../controllers/data_controller.dart';
import '../widgets/user_navbar.dart';
import '../settings/settings_page.dart';
import 'user_jadwal.dart';
import 'user_riwayat.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _HomeContent(),
    const UserJadwalScreen(),
    const UserRiwayatScreen(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: UserNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    Get.put(UserController());
    Get.put(DataController()); // Ensure Global Data Controller is ready
    final UserController userController = Get.find();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildModernHeader(userController),
            const SizedBox(height: 32),
            _buildBloodCard(userController),
            const SizedBox(height: 32),
            Text(
              "Layanan",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.25,
              children: [
                _buildServiceCard(
                  context,
                  icon: Icons.calendar_month_rounded,
                  label: "Jadwal Donor",
                  color: Colors.redAccent,
                  onTap: () => Navigator.pushNamed(context, '/jadwal'),
                ),
                _buildServiceCard(
                  context,
                  icon: Icons.history_rounded,
                  label: "Riwayat",
                  color: Colors.grey.shade700,
                  onTap: () => Navigator.pushNamed(context, '/riwayat'),
                ),
                _buildServiceCard(
                  context,
                  icon: Icons.location_on_rounded,
                  label: "Lokasi Unit",
                  color: Colors.red.shade700,
                  onTap: () => Navigator.pushNamed(context, '/lokasi_unit'),
                ),
                _buildServiceCard(
                  context,
                  icon: Icons.card_membership_rounded,
                  label: "Kartu Digital",
                  color: Colors.redAccent.shade100,
                  onTap: () => Navigator.pushNamed(context, '/kartu_donor'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Berita & Informasi",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                    letterSpacing: -0.5,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Lihat Semua",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildNewsItem(
              context,
              title: "Manfaat Donor Darah Bagi Kesehatan Jantung",
              category: "KESEHATAN",
              date: "2 Jam yang lalu",
              imageUrl:
                  "https://images.unsplash.com/photo-1615461066841-6116e61058f4?q=80&w=1000&auto=format&fit=crop",
              content: """
Tahukah Anda bahwa mendonorkan darah secara teratur dapat memberikan manfaat besar bagi kesehatan jantung Anda?

Sebuah penelitian yang diterbitkan dalam American Journal of Epidemiology menunjukkan bahwa pendonor darah aktif memiliki risiko 88% lebih rendah terkena serangan jantung. Hal ini disebabkan karena donor darah membantu mengurangi kelebihan zat besi dalam tubuh.

Selain itu, donor darah juga membantu:
1. Merangsang produksi sel darah merah baru.
2. Membantu mendeteksi penyakit serius lebih dini melalui skrining darah.
3. Membakar kalori (sekitar 650 kalori per donasi).
4. Memberikan kepuasan batin karena telah membantu sesama.

Jadi, jangan ragu untuk mendonorkan darah Anda secara rutin setiap 3 bulan sekali!
              """,
            ),
            const SizedBox(height: 16),
            _buildNewsItem(
              context,
              title: "Jadwal Mobil Unit Keliling Minggu Ini",
              category: "EVENT",
              date: "Kemarin",
              imageUrl:
                  "https://images.unsplash.com/photo-1579154204601-01588f351e67?q=80&w=1000&auto=format&fit=crop",
              content: """
Halo Sahabat Donor! Berikut adalah jadwal Mobil Unit Keliling (MUK) untuk minggu ini di wilayah Solo Raya:

- Senin: Depan Balai Kota Surakarta (08.00 - 12.00)
- Selasa: Universitas Sebelas Maret, Gedung Rektorat (09.00 - 13.00)
- Rabu: Solo Paragon Mall (10.00 - 14.00)
- Kamis: Alun-Alun Karanganyar (08.00 - 11.00)
- Jumat: Masjid Raya Klaten (Usai Sholat Jumat - 15.00)

Pastikan Anda dalam kondisi sehat, sudah makan, dan cukup tidur sebelum mendonorkan darah. Jangan lupa bawa KTP Anda!

Kami tunggu kedatangan Anda untuk berbagi kehidupan.
              """,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeader(UserController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Selamat Datang,",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Obx(
              () => Text(
                controller.currentUser.value.nama,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            image: const DecorationImage(
              image: AssetImage('assets/images/logo_donor.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBloodCard(UserController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.red.shade900, // Deep Red
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.red.shade900.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Obx(
                      () => Text(
                        controller.riwayatDonor.isNotEmpty
                            ? "Pendonor Aktif"
                            : "Pendonor Baru",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.favorite, color: Colors.white, size: 28),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Golongan Darah",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => Text(
                      controller.currentUser.value.golDarah,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Total Donor",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => Text(
                      "${controller.riwayatDonor.length}x",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsItem(
    BuildContext context, {
    required String title,
    required String category,
    required String date,
    required String imageUrl,
    required String content,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/detail_berita',
          arguments: {
            'title': title,
            'category': category,
            'date': date,
            'imageUrl': imageUrl,
            'content': content,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                  onError: (obj, stack) {}, // Handle error silently
                ),
              ),
              child:
                  null, // Removed icon fallback inside, handled by NetworkImage error logic or placeholder if needed.
              // For robustness, could wrap in ClipRRect and use Image.network with errorBuilder
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
