const express = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const { authMiddleware, adminOnly } = require('../middlewares/authMiddleware');
const galleryController = require('../controllers/galleryController');

const router = express.Router();

// Pastikan direktori uploads/gallery tersedia
const galleryUploadDir = path.join(__dirname, '..', 'uploads', 'gallery');
if (!fs.existsSync(galleryUploadDir)) {
  fs.mkdirSync(galleryUploadDir, { recursive: true });
}

// Konfigurasi Multer untuk upload foto
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, galleryUploadDir);
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = `${Date.now()}-${Math.round(Math.random() * 1e9)}`;
    const ext = path.extname(file.originalname) || '.jpg';
    cb(null, `img_${uniqueSuffix}${ext}`);
  },
});

const upload = multer({
  storage,
  limits: { fileSize: 10 * 1024 * 1024 }, // Max 10MB
  fileFilter: (req, file, cb) => {
    const allowedTypes = /jpeg|jpg|png|webp|gif/;
    const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase());
    const mimetype = allowedTypes.test(file.mimetype);
    if (extname || mimetype) {
      return cb(null, true);
    }
    cb(new Error('Hanya file gambar (jpg, jpeg, png, webp, gif) yang diizinkan.'));
  },
});

// GET /api/gallery - Ambil daftar foto (Public / Mobile / Web)
router.get('/', galleryController.getAll);

// POST /api/gallery - Tambah foto baru (Admin Only)
router.post('/', authMiddleware, adminOnly, upload.single('image'), galleryController.create);

// PUT /api/gallery/:id - Edit data/foto (Admin Only)
router.put('/:id', authMiddleware, adminOnly, upload.single('image'), galleryController.update);

// DELETE /api/gallery/:id - Hapus foto (Admin Only)
router.delete('/:id', authMiddleware, adminOnly, galleryController.delete);

module.exports = router;
