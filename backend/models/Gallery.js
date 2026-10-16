const { pool } = require('../config/database');

/**
 * Model Gallery - Operasi database untuk tabel galleries (Galeri & About Poca).
 */
const Gallery = {
  /**
   * Buat tabel galleries jika belum ada.
   */
  createTable: async () => {
    await pool.execute(`
      CREATE TABLE IF NOT EXISTS galleries (
        id INT AUTO_INCREMENT PRIMARY KEY,
        title VARCHAR(255) DEFAULT NULL,
        image_url VARCHAR(500) NOT NULL,
        category ENUM('galeri', 'about') NOT NULL DEFAULT 'galeri',
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    `);
  },

  /**
   * Ambil semua data foto (opsional filter berdasarkan category: 'galeri' atau 'about').
   * @param {string} [category]
   * @returns {Promise<Array>}
   */
  findAll: async (category) => {
    let query = 'SELECT * FROM galleries';
    const params = [];

    if (category && (category === 'galeri' || category === 'about')) {
      query += ' WHERE category = ?';
      params.push(category);
    }

    query += ' ORDER BY created_at DESC, id DESC';

    const [rows] = await pool.execute(query, params);
    return rows;
  },

  /**
   * Ambil detail item berdasarkan ID.
   * @param {number} id
   * @returns {Promise<object|null>}
   */
  findById: async (id) => {
    const [rows] = await pool.execute('SELECT * FROM galleries WHERE id = ?', [id]);
    return rows[0] || null;
  },

  /**
   * Tambah item foto baru.
   * @param {object} param - { title, image_url, category }
   * @returns {Promise<object>}
   */
  create: async ({ title, image_url, category }) => {
    const [result] = await pool.execute(
      'INSERT INTO galleries (title, image_url, category) VALUES (?, ?, ?)',
      [title || null, image_url, category || 'galeri']
    );

    return {
      id: result.insertId,
      title,
      image_url,
      category: category || 'galeri',
    };
  },

  /**
   * Hapus item foto berdasarkan ID.
   * @param {number} id
   * @returns {Promise<object>}
   */
  delete: async (id) => {
    const [result] = await pool.execute('DELETE FROM galleries WHERE id = ?', [id]);
    return result;
  },

  /**
   * Update item foto berdasarkan ID.
   * @param {number} id
   * @param {object} param - { title, category, image_url }
   * @returns {Promise<object>}
   */
  update: async (id, { title, category, image_url }) => {
    let query = 'UPDATE galleries SET title = ?, category = ?';
    const params = [title !== undefined ? title : null, category || 'galeri'];

    if (image_url) {
      query += ', image_url = ?';
      params.push(image_url);
    }

    query += ' WHERE id = ?';
    params.push(id);

    const [result] = await pool.execute(query, params);
    return result;
  },

  /**
   * Hitung total item dalam tabel.
   * @returns {Promise<number>}
   */
  count: async () => {
    const [rows] = await pool.execute('SELECT COUNT(*) as total FROM galleries');
    return rows[0]?.total || 0;
  },
};

module.exports = Gallery;
