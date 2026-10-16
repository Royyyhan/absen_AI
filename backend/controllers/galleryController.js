const path = require('path');
const fs = require('fs');
const Gallery = require('../models/Gallery');

/**
 * Controller untuk Galeri & About Poca
 */
const galleryController = {
  /**
   * Ambil daftar foto
   * Query: ?category=galeri atau ?category=about
   */
  getAll: async (req, res, next) => {
    try {
      const { category } = req.query;
      const items = await Gallery.findAll(category);

      res.status(200).json({
        success: true,
        data: items,
      });
    } catch (error) {
      next(error);
    }
  },

  /**
   * Upload / Tambah foto baru (Admin Only)
   */
  create: async (req, res, next) => {
    try {
      const { title, category } = req.body;

      if (!req.file) {
        return res.status(400).json({
          success: false,
          message: 'File gambar wajib diunggah.',
        });
      }

      // Relative path to be stored in DB
      const imageUrl = `/gallery/${req.file.filename}`;
      const validCategory = category === 'about' ? 'about' : 'galeri';

      const newItem = await Gallery.create({
        title: title || '',
        image_url: imageUrl,
        category: validCategory,
      });

      res.status(201).json({
        success: true,
        message: 'Foto berhasil ditambahkan.',
        data: newItem,
      });
    } catch (error) {
      next(error);
    }
  },

  /**
   * Hapus foto (Admin Only)
   */
  delete: async (req, res, next) => {
    try {
      const { id } = req.params;
      const item = await Gallery.findById(id);

      if (!item) {
        return res.status(404).json({
          success: false,
          message: 'Foto tidak ditemukan.',
        });
      }

      // Hapus file fisik jika ada di folder uploads/gallery
      if (item.image_url && item.image_url.startsWith('/gallery/')) {
        const filename = item.image_url.replace('/gallery/', '');
        const filePath = path.join(__dirname, '..', 'uploads', 'gallery', filename);
        if (fs.existsSync(filePath)) {
          try {
            fs.unlinkSync(filePath);
          } catch (err) {
            console.error('Gagal menghapus file gambar:', err.message);
          }
        }
      }

      await Gallery.delete(id);

      res.status(200).json({
        success: true,
        message: 'Foto berhasil dihapus.',
      });
    } catch (error) {
      next(error);
    }
  },

  /**
   * Update / Edit data foto (Admin Only)
   */
  update: async (req, res, next) => {
    try {
      const { id } = req.params;
      const { title, category } = req.body;
      const item = await Gallery.findById(id);

      if (!item) {
        return res.status(404).json({
          success: false,
          message: 'Foto tidak ditemukan.',
        });
      }

      let imageUrl = item.image_url;

      // Jika ada gambar baru yang diunggah
      if (req.file) {
        if (item.image_url && item.image_url.startsWith('/gallery/')) {
          const oldFilename = item.image_url.replace('/gallery/', '');
          const oldFilePath = path.join(__dirname, '..', 'uploads', 'gallery', oldFilename);
          if (fs.existsSync(oldFilePath)) {
            try {
              fs.unlinkSync(oldFilePath);
            } catch (err) {
              console.error('Gagal menghapus file lama:', err.message);
            }
          }
        }
        imageUrl = `/gallery/${req.file.filename}`;
      }

      const validCategory = category === 'about' ? 'about' : 'galeri';

      await Gallery.update(id, {
        title: title !== undefined ? title : item.title,
        category: category ? validCategory : item.category,
        image_url: req.file ? imageUrl : undefined,
      });

      const updatedItem = await Gallery.findById(id);

      res.status(200).json({
        success: true,
        message: 'Foto berhasil diperbarui.',
        data: updatedItem,
      });
    } catch (error) {
      next(error);
    }
  },
};

module.exports = galleryController;
