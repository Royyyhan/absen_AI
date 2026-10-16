import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../widgets/liquid_glass.dart';
import 'photo_gallery_screen.dart';

/// Halaman Beranda - Menu utama dengan pilihan Absen, Izin, Galeri, dan About Poca
class HomeScreen extends StatelessWidget {
  final List<CameraDescription> cameras;
  final void Function(int index)? onSwitchTab;

  const HomeScreen({super.key, required this.cameras, this.onSwitchTab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: const LiquidGlassAppBar(
        title: 'Beranda',
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image sama dengan halaman lainnya
          Image.asset(
            'lib/asset/baground/BG.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(color: const Color(0xFF365C4A)),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.20),
                  Colors.black.withValues(alpha: 0.08),
                  Colors.black.withValues(alpha: 0.30),
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // Welcome Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.94),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.8)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF365C4A)
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.dashboard_rounded,
                            color: Color(0xFF365C4A),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selamat Datang',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF242721),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Pilih menu yang ingin Anda akses',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ─── Grid Menu 2x2 ───
                  // Baris 1: [ Absen ]       [ Izin ]
                  // Baris 2: [ Galeri ]      [ About Poca ]
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.82,
                    children: [
                      // 1. Menu Absen
                      _buildMenuCard(
                        context: context,
                        title: 'Absen',
                        subtitle: 'Presensi Masuk & Pulang',
                        icon: Icons.fingerprint_rounded,
                        gradientColors: const [
                          Color(0xFF10B981),
                          Color(0xFF059669),
                        ],
                        onTap: () {
                          onSwitchTab?.call(1);
                        },
                      ),

                      // 2. Menu Izin
                      _buildMenuCard(
                        context: context,
                        title: 'Izin',
                        subtitle: 'Pengajuan Izin Kerja',
                        icon: Icons.description_rounded,
                        gradientColors: const [
                          Color(0xFF6366F1),
                          Color(0xFF4F46E5),
                        ],
                        onTap: () {
                          onSwitchTab?.call(2);
                        },
                      ),

                      // 3. Menu Galeri (di bawah Absen)
                      _buildMenuCard(
                        context: context,
                        title: 'Galeri',
                        subtitle: 'Foto & Dokumentasi',
                        icon: Icons.photo_library_rounded,
                        gradientColors: const [
                          Color(0xFFF59E0B),
                          Color(0xFFD97706),
                        ],
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const PhotoGalleryScreen(
                                title: 'Galeri',
                                category: 'galeri',
                              ),
                            ),
                          );
                        },
                      ),

                      // 4. Menu About Poca (di sebelah Galeri, di bawah Izin)
                      _buildMenuCard(
                        context: context,
                        title: 'About Poca',
                        subtitle: 'Profil & Dokumentasi',
                        icon: Icons.business_rounded,
                        gradientColors: const [
                          Color(0xFF0EA5E9),
                          Color(0xFF0284C7),
                        ],
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const PhotoGalleryScreen(
                                title: 'About Poca',
                                category: 'about',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Card Menu Navigasi (Absen, Izin, Galeri, About Poca) dengan tampilan seragam
  Widget _buildMenuCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Circle with Gradient
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradientColors,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: gradientColors[0].withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF242721),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Subtitle
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
