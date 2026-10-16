import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_constants.dart';

class GalleryItem {
  final int? id;
  final String title;
  final String imageUrl;
  final String category;
  final bool isAsset;

  const GalleryItem({
    this.id,
    required this.title,
    required this.imageUrl,
    required this.category,
    this.isAsset = false,
  });

  factory GalleryItem.fromJson(Map<String, dynamic> json) {
    final rawUrl = json['image_url']?.toString() ?? '';
    // Format full URL jika dari backend
    final fullUrl = rawUrl.startsWith('http')
        ? rawUrl
        : '${ApiConstants.baseUrl}$rawUrl';

    return GalleryItem(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      title: json['title']?.toString() ?? '',
      imageUrl: fullUrl,
      category: json['category']?.toString() ?? 'galeri',
      isAsset: false,
    );
  }
}

class GalleryService {
  /// Ambil foto berdasarkan kategori ('galeri' atau 'about').
  /// Mengutamakan data dari backend API (CRUD website),
  /// dan otomatis fallback ke aset lokal jika backend belum ada foto atau offline.
  static Future<List<GalleryItem>> fetchItems(String category) async {
    try {
      final uri = Uri.parse('${ApiConstants.galleryUrl}?category=$category');
      final response = await http.get(uri).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] is List) {
          final list = (data['data'] as List)
              .map((item) => GalleryItem.fromJson(item))
              .toList();

          if (list.isNotEmpty) {
            return list;
          }
        }
      }
    } catch (e) {
      debugPrint('[GalleryService] Gagal fetch dari server ($category): $e. Menggunakan fallback aset.');
    }

    // Fallback aset lokal jika server kosong atau offline
    return getFallbackAssetItems(category);
  }

  /// Daftar foto fallback dari aset lokal
  static List<GalleryItem> getFallbackAssetItems(String category) {
    if (category == 'about') {
      return const [
        GalleryItem(
          title: 'PT Poca Jaringan Solusi',
          imageUrl: 'assets/about/poca1.png',
          category: 'about',
          isAsset: true,
        ),
        GalleryItem(
          title: 'Kultur & Kantor Poca',
          imageUrl: 'assets/about/poca2.png',
          category: 'about',
          isAsset: true,
        ),
      ];
    }

    // Default 'galeri'
    return const [
      GalleryItem(
        title: 'Dokumentasi Galeri 1',
        imageUrl: 'assets/gallery/sample1.png',
        category: 'galeri',
        isAsset: true,
      ),
      GalleryItem(
        title: 'Dokumentasi Galeri 2',
        imageUrl: 'assets/gallery/sample2.png',
        category: 'galeri',
        isAsset: true,
      ),
    ];
  }
}
