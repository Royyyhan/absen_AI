const { pool } = require('../config/database');

/**
 * Model Location - Operasi database untuk tabel locations (lokasi kantor/kampus).
 */
const Location = {
  /**
   * Ambil lokasi aktif (utama).
   * Jika ada beberapa lokasi, ambil yang aktif.
   * @returns {Promise<object|null>}
   */
  getActive: async () => {
    const [rows] = await pool.execute(
      'SELECT * FROM locations WHERE is_active = 1 LIMIT 1'
    );
    if (rows[0]) return rows[0];

    // Fallback: Jika tidak ada lokasi dengan is_active = 1 tapi ada lokasi di database
    const [fallbackRows] = await pool.execute(
      'SELECT * FROM locations ORDER BY id ASC LIMIT 1'
    );
    if (fallbackRows[0]) {
      await pool.execute('UPDATE locations SET is_active = 1 WHERE id = ?', [fallbackRows[0].id]);
      fallbackRows[0].is_active = 1;
      return fallbackRows[0];
    }
    return null;
  },

  /**
   * Ambil semua lokasi.
   * @returns {Promise<Array>}
   */
  findAll: async () => {
    const [rows] = await pool.execute(
      'SELECT * FROM locations ORDER BY is_active DESC, created_at DESC'
    );
    return rows;
  },

  /**
   * Cari lokasi berdasarkan ID.
   * @param {number} id
   * @returns {Promise<object|null>}
   */
  findById: async (id) => {
    const [rows] = await pool.execute('SELECT * FROM locations WHERE id = ?', [id]);
    return rows[0] || null;
  },

  /**
   * Buat lokasi baru.
   * @param {object} data - { name, latitude, longitude, radius, is_active }
   * @returns {Promise<object>}
   */
  create: async ({ name, latitude, longitude, radius, is_active = 1 }) => {
    // Cek apakah sudah ada lokasi di database
    const [existing] = await pool.execute('SELECT COUNT(*) as count FROM locations');
    const hasExisting = existing[0] && existing[0].count > 0;

    // Jika ini lokasi pertama, otomatis aktifkan
    const shouldBeActive = !hasExisting || Boolean(is_active);

    if (shouldBeActive) {
      await pool.execute('UPDATE locations SET is_active = 0');
    }

    const [result] = await pool.execute(
      'INSERT INTO locations (name, latitude, longitude, radius, is_active) VALUES (?, ?, ?, ?, ?)',
      [name, latitude, longitude, radius, shouldBeActive ? 1 : 0]
    );
    return { id: result.insertId, name, latitude, longitude, radius, is_active: shouldBeActive ? 1 : 0 };
  },

  /**
   * Update lokasi.
   * @param {number} id
   * @param {object} data
   * @returns {Promise<object>}
   */
  update: async (id, { name, latitude, longitude, radius, is_active }) => {
    if (is_active) {
      await pool.execute('UPDATE locations SET is_active = 0 WHERE id != ?', [id]);
    }

    const [result] = await pool.execute(
      `UPDATE locations SET name = ?, latitude = ?, longitude = ?, radius = ?, is_active = ?, updated_at = NOW()
       WHERE id = ?`,
      [name, latitude, longitude, radius, is_active ? 1 : 0, id]
    );

    // Pastikan tetap ada minimal 1 lokasi aktif jika ada data
    const [active] = await pool.execute('SELECT id FROM locations WHERE is_active = 1 LIMIT 1');
    if (!active[0]) {
      await pool.execute('UPDATE locations SET is_active = 1 WHERE id = ?', [id]);
    }

    return result;
  },

  /**
   * Aktifkan lokasi tertentu
   * @param {number} id
   */
  setActive: async (id) => {
    await pool.execute('UPDATE locations SET is_active = 0');
    const [result] = await pool.execute('UPDATE locations SET is_active = 1 WHERE id = ?', [id]);
    return result;
  },

  /**
   * Hapus lokasi.
   * @param {number} id
   * @returns {Promise<object>}
   */
  delete: async (id) => {
    const [result] = await pool.execute('DELETE FROM locations WHERE id = ?', [id]);

    // Jika lokasi aktif terhapus, aktifkan lokasi lain yang masih ada
    const [active] = await pool.execute('SELECT id FROM locations WHERE is_active = 1 LIMIT 1');
    if (!active[0]) {
      const [remaining] = await pool.execute('SELECT id FROM locations ORDER BY id ASC LIMIT 1');
      if (remaining[0]) {
        await pool.execute('UPDATE locations SET is_active = 1 WHERE id = ?', [remaining[0].id]);
      }
    }

    return result;
  },
};

module.exports = Location;
