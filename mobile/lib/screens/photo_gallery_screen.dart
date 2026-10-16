import 'package:flutter/material.dart';
import '../services/gallery_service.dart';
import '../widgets/liquid_glass.dart';
import '../widgets/fullscreen_image_viewer.dart';

/// Halaman Galeri / About Poca dengan daftar foto dan keterangan judul (galleries.title)
class PhotoGalleryScreen extends StatefulWidget {
  final String title;
  final String category; // 'galeri' atau 'about'

  const PhotoGalleryScreen({
    super.key,
    required this.title,
    required this.category,
  });

  @override
  State<PhotoGalleryScreen> createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends State<PhotoGalleryScreen> {
  List<GalleryItem> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final items = await GalleryService.fetchItems(widget.category);
      if (mounted) {
        setState(() {
          _items = items;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _items = GalleryService.getFallbackAssetItems(widget.category);
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: LiquidGlassAppBar(
        title: widget.title,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: Color(0xFF242721),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Kembali ke Beranda',
        ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background konsisten
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

          // Konten Foto
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _loadPhotos,
              color: const Color(0xFF365C4A),
              backgroundColor: Colors.white,
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : _items.isEmpty
                      ? _buildEmptyState()
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(18, 12, 18, 40),
                          itemCount: _items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 18),
                          itemBuilder: (context, index) {
                            final item = _items[index];
                            return _buildPhotoCard(item, index);
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  /// Kartu Foto dengan Gambar & Keterangan Judul
  Widget _buildPhotoCard(GalleryItem item, int index) {
    final titleText = item.title.trim().isNotEmpty
        ? item.title.trim()
        : (widget.category == 'about'
            ? 'Tentang PT Poca Solusi'
            : 'Dokumentasi Galeri #${index + 1}');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          FullscreenImageViewer.open(
            context,
            items: _items,
            initialIndex: index,
          );
        },
        borderRadius: BorderRadius.circular(22),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 16,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.85),
              width: 1.2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Foto dengan Aspect Ratio Elegan
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(21)),
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 10,
                      child: Container(
                        color: Colors.grey.shade200,
                        child: item.isAsset
                            ? Image.asset(
                                item.imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (_, __, ___) => _buildImageError(),
                              )
                            : Image.network(
                                item.imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: progress.expectedTotalBytes != null
                                          ? progress.cumulativeBytesLoaded /
                                              progress.expectedTotalBytes!
                                          : null,
                                      strokeWidth: 2.5,
                                      color: const Color(0xFF365C4A),
                                    ),
                                  );
                                },
                                errorBuilder: (_, __, ___) => _buildImageError(),
                              ),
                      ),
                    ),

                    // Badge Petunjuk Tap / Fullscreen di pojok foto
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.zoom_out_map_rounded,
                              size: 13,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Lihat Penuh',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bagian Keterangan Foto (galleries.title)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Aksen garis kecil
                        Container(
                          width: 4,
                          height: 18,
                          margin: const EdgeInsets.only(top: 2, right: 10),
                          decoration: BoxDecoration(
                            color: widget.category == 'about'
                                ? const Color(0xFF0EA5E9)
                                : const Color(0xFFF59E0B),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            titleText,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF242721),
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      color: Colors.grey.shade100,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.broken_image_rounded, size: 36, color: Colors.grey),
            SizedBox(height: 6),
            Text(
              'Gagal memuat foto',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(32),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.photo_library_outlined,
                  size: 32,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Belum Ada Foto di ${widget.title}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF242721),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Foto dapat diunggah melalui Dashboard Website Admin.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
