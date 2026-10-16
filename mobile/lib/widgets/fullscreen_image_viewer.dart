import 'package:flutter/material.dart';
import '../services/gallery_service.dart';

class FullscreenImageViewer extends StatefulWidget {
  final List<GalleryItem> items;
  final int initialIndex;

  const FullscreenImageViewer({
    super.key,
    required this.items,
    this.initialIndex = 0,
  });

  static void open(BuildContext context, {required List<GalleryItem> items, int initialIndex = 0}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withValues(alpha: 0.90),
        pageBuilder: (context, _, __) => FullscreenImageViewer(
          items: items,
          initialIndex: initialIndex,
        ),
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  State<FullscreenImageViewer> createState() => _FullscreenImageViewerState();
}

class _FullscreenImageViewerState extends State<FullscreenImageViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // PageView untuk swipe gambar
          PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return InteractiveViewer(
                minScale: 0.8,
                maxScale: 4.0,
                child: Center(
                  child: Hero(
                    tag: 'gallery_${item.category}_${item.id ?? index}',
                    child: item.isAsset
                        ? Image.asset(
                            item.imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => _buildErrorWidget(),
                          )
                        : Image.network(
                            item.imageUrl,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: Colors.white,
                                ),
                              );
                            },
                            errorBuilder: (_, __, ___) => _buildErrorWidget(),
                          ),
                  ),
                ),
              );
            },
          ),

          // Header Bar: Close button & Counter
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close Button
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),

                  // Indicator
                  if (widget.items.length > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24, width: 0.8),
                      ),
                      child: Text(
                        '${_currentIndex + 1} / ${widget.items.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Bottom Bar: Title Caption
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Text(
                  widget.items[_currentIndex].title.isNotEmpty
                      ? widget.items[_currentIndex].title
                      : (widget.items[_currentIndex].category == 'about'
                          ? 'About Poca'
                          : 'Galeri Foto'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.broken_image_rounded, color: Colors.white70, size: 48),
          SizedBox(height: 8),
          Text(
            'Gagal memuat gambar',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
