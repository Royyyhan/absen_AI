import React, { useState, useEffect, useRef } from 'react';
import { fetchGalleryItems, uploadGalleryItem, updateGalleryItem, deleteGalleryItem } from '../../services/api';
import { getImageUrl } from '../../utils/imageUrl';

export default function DataGalleryPage({ onBack, onLogout }) {
  const [activeTab, setActiveTab] = useState('galeri'); // 'galeri' | 'about'
  const [items, setItems] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState('');
  const [notification, setNotification] = useState(null);

  // Modal Upload State
  const [isUploadModalOpen, setIsUploadModalOpen] = useState(false);
  const [uploadTitle, setUploadTitle] = useState('');
  const [uploadCategory, setUploadCategory] = useState('galeri');
  const [uploadFile, setUploadFile] = useState(null);
  const [uploadPreviewUrl, setUploadPreviewUrl] = useState(null);
  const [isSubmittingUpload, setIsSubmittingUpload] = useState(false);

  // Modal Edit State
  const [isEditModalOpen, setIsEditModalOpen] = useState(false);
  const [editingItem, setEditingItem] = useState(null);
  const [editTitle, setEditTitle] = useState('');
  const [editCategory, setEditCategory] = useState('galeri');
  const [editFile, setEditFile] = useState(null);
  const [editPreviewUrl, setEditPreviewUrl] = useState(null);
  const [isSubmittingEdit, setIsSubmittingEdit] = useState(false);

  // Lightbox Preview State
  const [previewImage, setPreviewImage] = useState(null);

  // Delete Confirm State
  const [deletingId, setDeletingId] = useState(null);
  const [isDeleting, setIsDeleting] = useState(false);

  const uploadFileInputRef = useRef(null);
  const editFileInputRef = useRef(null);

  const showNotif = (type, message) => {
    setNotification({ type, message });
    setTimeout(() => setNotification(null), 3500);
  };

  const loadData = async (cat = activeTab) => {
    setLoading(true);
    try {
      const res = await fetchGalleryItems(cat);
      if (res && res.data) {
        setItems(res.data);
      } else {
        setItems([]);
      }
    } catch (err) {
      setItems([]);
      showNotif('error', 'Gagal memuat foto: ' + err.message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadData(activeTab);
  }, [activeTab]);

  const handleTabChange = (newTab) => {
    setActiveTab(newTab);
    setUploadCategory(newTab);
  };

  // --- Handlers Upload Modal ---
  const handleOpenUploadModal = () => {
    setUploadTitle('');
    setUploadCategory(activeTab);
    setUploadFile(null);
    setUploadPreviewUrl(null);
    setIsUploadModalOpen(true);
  };

  const handleCloseUploadModal = () => {
    if (uploadPreviewUrl) URL.revokeObjectURL(uploadPreviewUrl);
    setIsUploadModalOpen(false);
    setUploadFile(null);
    setUploadPreviewUrl(null);
  };

  const handleUploadFileSelect = (e) => {
    const file = e.target.files?.[0];
    if (file) {
      if (!file.type.startsWith('image/')) {
        showNotif('error', 'Mohon pilih file gambar yang valid (JPG, PNG, WebP).');
        return;
      }
      setUploadFile(file);
      setUploadPreviewUrl(URL.createObjectURL(file));
    }
  };

  const handleUploadSubmit = async (e) => {
    e.preventDefault();
    if (!uploadFile) {
      showNotif('error', 'Silakan pilih gambar terlebih dahulu.');
      return;
    }

    setIsSubmittingUpload(true);
    try {
      const formData = new FormData();
      formData.append('image', uploadFile);
      formData.append('title', uploadTitle.trim());
      formData.append('category', uploadCategory);

      await uploadGalleryItem(formData);
      showNotif('success', 'Foto baru berhasil diunggah.');
      handleCloseUploadModal();
      loadData(activeTab);
    } catch (err) {
      showNotif('error', err.message || 'Gagal mengunggah foto.');
    } finally {
      setIsSubmittingUpload(false);
    }
  };

  // --- Handlers Edit Modal ---
  const handleOpenEditModal = (item) => {
    setEditingItem(item);
    setEditTitle(item.title || '');
    setEditCategory(item.category || 'galeri');
    setEditFile(null);
    setEditPreviewUrl(null);
    setIsEditModalOpen(true);
  };

  const handleCloseEditModal = () => {
    if (editPreviewUrl) URL.revokeObjectURL(editPreviewUrl);
    setIsEditModalOpen(false);
    setEditingItem(null);
    setEditFile(null);
    setEditPreviewUrl(null);
  };

  const handleEditFileSelect = (e) => {
    const file = e.target.files?.[0];
    if (file) {
      if (!file.type.startsWith('image/')) {
        showNotif('error', 'Mohon pilih file gambar yang valid.');
        return;
      }
      setEditFile(file);
      setEditPreviewUrl(URL.createObjectURL(file));
    }
  };

  const handleEditSubmit = async (e) => {
    e.preventDefault();
    if (!editingItem) return;

    setIsSubmittingEdit(true);
    try {
      const formData = new FormData();
      formData.append('title', editTitle.trim());
      formData.append('category', editCategory);
      if (editFile) {
        formData.append('image', editFile);
      }

      await updateGalleryItem(editingItem.id, formData);
      showNotif('success', 'Data foto berhasil diperbarui.');
      handleCloseEditModal();
      loadData(activeTab);
    } catch (err) {
      showNotif('error', err.message || 'Gagal memperbarui foto.');
    } finally {
      setIsSubmittingEdit(false);
    }
  };

  // --- Handlers Hapus ---
  const handleDelete = async () => {
    if (!deletingId) return;
    setIsDeleting(true);
    try {
      await deleteGalleryItem(deletingId);
      showNotif('success', 'Foto berhasil dihapus.');
      setDeletingId(null);
      loadData(activeTab);
    } catch (err) {
      showNotif('error', err.message || 'Gagal menghapus foto.');
    } finally {
      setIsDeleting(false);
    }
  };

  // Filter items berdasarkan pencarian
  const filteredItems = items.filter((item) => {
    if (!searchQuery.trim()) return true;
    const q = searchQuery.toLowerCase().trim();
    const titleMatch = (item.title || '').toLowerCase().includes(q);
    const catMatch = (item.category || '').toLowerCase().includes(q);
    return titleMatch || catMatch;
  });

  return (
    <div style={styles.wrapper}>
      {/* ─── Top Header Bar (Persis Halaman Lain) ─── */}
      <header style={styles.header}>
        <div style={styles.headerInner}>
          <div style={styles.headerLeft}>
            <button
              onClick={onBack}
              style={styles.backBtn}
              title="Kembali ke Menu Utama"
              onMouseEnter={(e) => (e.currentTarget.style.background = 'rgba(30,90,138,0.08)')}
              onMouseLeave={(e) => (e.currentTarget.style.background = 'transparent')}
            >
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#1e5a8a" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
                <polyline points="15 18 9 12 15 6" />
              </svg>
            </button>
            <div style={styles.headerLogo}>
              <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <rect x="4" y="2" width="16" height="20" rx="2" ry="2" />
                <path d="M9 22v-4h6v4" />
                <path d="M8 6h.01" /><path d="M16 6h.01" /><path d="M12 6h.01" />
                <path d="M12 10h.01" /><path d="M12 14h.01" />
                <path d="M16 10h.01" /><path d="M16 14h.01" />
                <path d="M8 10h.01" /><path d="M8 14h.01" />
              </svg>
            </div>
            <div>
              <h1 style={styles.headerTitle}>PT Poca Jaringan Solusi</h1>
              <p style={styles.headerSubtitle}>Sistem Absensi Karyawan</p>
            </div>
          </div>
          <button
            onClick={onLogout}
            style={styles.logoutBtn}
            title="Keluar"
            onMouseEnter={(e) => (e.currentTarget.style.background = 'rgba(255,255,255,0.15)')}
            onMouseLeave={(e) => (e.currentTarget.style.background = 'transparent')}
          >
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
              <polyline points="16 17 21 12 16 7" />
              <line x1="21" y1="12" x2="9" y2="12" />
            </svg>
          </button>
        </div>
      </header>

      {/* ─── Main Content Area ─── */}
      <main style={styles.main}>
        {/* Toast Notification */}
        {notification && (
          <div
            style={{
              ...styles.toast,
              background: notification.type === 'error' ? '#fef2f2' : notification.type === 'success' ? '#f0fdf4' : '#eff6ff',
              borderColor: notification.type === 'error' ? '#fecaca' : notification.type === 'success' ? '#bbf7d0' : '#bfdbfe',
              color: notification.type === 'error' ? '#dc2626' : notification.type === 'success' ? '#16a34a' : '#1d4ed8',
            }}
          >
            <span>{notification.message}</span>
            <button onClick={() => setNotification(null)} style={styles.toastClose}>✕</button>
          </div>
        )}

        {/* ─── Page Title Row (Persis Approval Not Match) ─── */}
        <div style={styles.titleRow}>
          <div style={styles.titleLeft}>
            <div style={styles.titleIcon}>
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#1e5a8a" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                <circle cx="8.5" cy="8.5" r="1.5" />
                <polyline points="21 15 16 10 5 21" />
              </svg>
            </div>
            <div>
              <h2 style={styles.pageTitle}>Manajemen Galeri & About Poca</h2>
              <p style={styles.pageSubtitle}>
                Kelola foto dan dokumentasi yang ditampilkan pada aplikasi mobile presensi
              </p>
            </div>
          </div>
        </div>

        {/* ─── Toolbar: Search + Filter Tabs + Tombol Unggah ─── */}
        <div style={styles.toolbar}>
          <div style={styles.toolbarLeft}>
            {/* Search Box */}
            <div style={styles.searchBox}>
              <span style={styles.searchIcon}>
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#64748b" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <circle cx="11" cy="11" r="8" />
                  <line x1="21" y1="21" x2="16.65" y2="16.65" />
                </svg>
              </span>
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Cari foto atau keterangan..."
                style={styles.searchInput}
              />
              {searchQuery && (
                <button
                  type="button"
                  onClick={() => setSearchQuery('')}
                  style={styles.clearSearchBtn}
                >
                  ✕
                </button>
              )}
            </div>

            {/* Filter Tabs: Galeri Foto vs About Poca */}
            <div style={styles.filterTabs}>
              <button
                type="button"
                onClick={() => handleTabChange('galeri')}
                style={{
                  ...styles.tabBtn,
                  ...(activeTab === 'galeri' ? styles.tabBtnActive : {}),
                }}
              >
                Galeri Foto
              </button>
              <button
                type="button"
                onClick={() => handleTabChange('about')}
                style={{
                  ...styles.tabBtn,
                  ...(activeTab === 'about' ? styles.tabBtnActive : {}),
                }}
              >
                About Poca
              </button>
            </div>
          </div>

          <div style={styles.toolbarRight}>
            <button onClick={handleOpenUploadModal} style={styles.primaryBtn}>
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
                <line x1="12" y1="5" x2="12" y2="19" />
                <line x1="5" y1="12" x2="19" y2="12" />
              </svg>
              Unggah Foto Baru
            </button>
          </div>
        </div>

        {/* ─── Main White Container Card ─── */}
        <div style={styles.contentContainer}>
          {loading ? (
            <div style={styles.loadingBox}>
              <div className="w-8 h-8 border-3 border-[#1e5a8a] border-t-transparent rounded-full animate-spin" />
              <p style={{ marginTop: 12, color: '#64748b', fontSize: 14 }}>Memuat daftar foto...</p>
            </div>
          ) : filteredItems.length === 0 ? (
            <div style={styles.emptyBox}>
              <div style={styles.emptyIconCircle}>
                <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="#94a3b8" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
                  <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                  <circle cx="8.5" cy="8.5" r="1.5" />
                  <polyline points="21 15 16 10 5 21" />
                </svg>
              </div>
              <h3 style={styles.emptyTitle}>
                {searchQuery
                  ? 'Tidak ada foto yang cocok dengan pencarian'
                  : `Belum ada foto di ${activeTab === 'galeri' ? 'Galeri Foto' : 'About Poca'}`}
              </h3>
              <p style={styles.emptySubtitle}>
                {searchQuery
                  ? 'Silakan coba kata kunci lain atau kosongkan kolom pencarian.'
                  : 'Klik tombol "+ Unggah Foto Baru" di atas untuk menambahkan foto pertama.'}
              </p>
            </div>
          ) : (
            <div style={styles.grid}>
              {filteredItems.map((item) => {
                const fullImageUrl = getImageUrl(item.image_url);

                return (
                  <div key={item.id} style={styles.photoCard}>
                    {/* Image Preview Container */}
                    <div
                      style={styles.cardImageWrapper}
                      onClick={() => setPreviewImage(item)}
                      title="Klik untuk melihat resolusi penuh"
                    >
                      <img
                        src={fullImageUrl}
                        alt={item.title || 'Foto'}
                        style={styles.cardImage}
                        loading="lazy"
                        onError={(e) => {
                          e.currentTarget.onerror = null;
                          e.currentTarget.src =
                            'data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="300" height="200" viewBox="0 0 300 200" fill="%23f1f5f9"><rect width="300" height="200" fill="%23f1f5f9"/><text x="50%" y="50%" fill="%2394a3b8" dominant-baseline="middle" text-anchor="middle" font-family="sans-serif" font-size="14">Foto Tidak Dapat Dimuat</text></svg>';
                        }}
                      />
                      <div style={styles.imageOverlay}>
                        <span style={styles.overlayText}>
                          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                            <circle cx="11" cy="11" r="8" />
                            <line x1="21" y1="21" x2="16.65" y2="16.65" />
                            <line x1="11" y1="8" x2="11" y2="14" />
                            <line x1="8" y1="11" x2="14" y2="11" />
                          </svg>
                          Lihat Penuh
                        </span>
                      </div>
                    </div>

                    {/* Card Content & Meta */}
                    <div style={styles.cardBody}>
                      <div style={styles.cardTitleRow}>
                        <h4 style={styles.cardTitle} title={item.title || '(Tanpa Keterangan)'}>
                          {item.title && item.title.trim() ? item.title.trim() : <span style={{ color: '#94a3b8', fontStyle: 'italic' }}>(Tanpa Keterangan)</span>}
                        </h4>
                        <span
                          style={{
                            ...styles.badge,
                            background: item.category === 'about' ? '#ede9fe' : '#e0f2fe',
                            color: item.category === 'about' ? '#6d28d9' : '#0369a1',
                          }}
                        >
                          {item.category === 'about' ? 'About Poca' : 'Galeri'}
                        </span>
                      </div>

                      <div style={styles.cardFooter}>
                        <span style={styles.dateText}>
                          {item.created_at
                            ? new Date(item.created_at).toLocaleDateString('id-ID', {
                                day: 'numeric',
                                month: 'short',
                                year: 'numeric',
                              })
                            : '-'}
                        </span>

                        <div style={styles.cardActions}>
                          {/* Tombol Edit */}
                          <button
                            type="button"
                            onClick={() => handleOpenEditModal(item)}
                            style={styles.editBtn}
                            title="Edit keterangan atau ganti foto"
                          >
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                              <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                              <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                            </svg>
                            Edit
                          </button>

                          {/* Tombol Hapus */}
                          <button
                            type="button"
                            onClick={() => setDeletingId(item.id)}
                            style={styles.deleteBtn}
                            title="Hapus foto ini"
                          >
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                              <polyline points="3 6 5 6 21 6" />
                              <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" />
                            </svg>
                            Hapus
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          )}

          {/* Footer Info Count */}
          <div style={styles.footerInfo}>
            <span>
              Menampilkan <strong>{filteredItems.length}</strong> foto di tab{' '}
              <strong>{activeTab === 'galeri' ? 'Galeri' : 'About Poca'}</strong>
            </span>
          </div>
        </div>
      </main>

      {/* ─── Modal 1: Unggah Foto Baru ─── */}
      {isUploadModalOpen && (
        <div style={styles.modalBackdrop}>
          <div style={styles.modalCard}>
            <div style={styles.modalHeader}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                <div style={styles.modalHeaderIcon}>
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#1e5a8a" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <line x1="12" y1="5" x2="12" y2="19" />
                    <line x1="5" y1="12" x2="19" y2="12" />
                  </svg>
                </div>
                <h3 style={styles.modalTitle}>Unggah Foto Baru</h3>
              </div>
              <button onClick={handleCloseUploadModal} style={styles.closeBtn}>✕</button>
            </div>

            <form onSubmit={handleUploadSubmit} style={styles.modalBody}>
              {/* Kategori Radio */}
              <div style={styles.formGroup}>
                <label style={styles.label}>Tampilkan di Bagian:</label>
                <div style={{ display: 'flex', gap: 12 }}>
                  <label style={{ ...styles.radioLabel, ...(uploadCategory === 'galeri' ? styles.radioLabelActive : {}) }}>
                    <input
                      type="radio"
                      name="uploadCategory"
                      value="galeri"
                      checked={uploadCategory === 'galeri'}
                      onChange={() => setUploadCategory('galeri')}
                      style={{ accentColor: '#1e5a8a' }}
                    />
                    Galeri Foto
                  </label>
                  <label style={{ ...styles.radioLabel, ...(uploadCategory === 'about' ? styles.radioLabelActive : {}) }}>
                    <input
                      type="radio"
                      name="uploadCategory"
                      value="about"
                      checked={uploadCategory === 'about'}
                      onChange={() => setUploadCategory('about')}
                      style={{ accentColor: '#1e5a8a' }}
                    />
                    About Poca
                  </label>
                </div>
              </div>

              {/* Judul / Keterangan Input */}
              <div style={styles.formGroup}>
                <label style={styles.label}>Keterangan Foto (galleries.title):</label>
                <input
                  type="text"
                  placeholder="Contoh: Gathering PT Poca Solusi 2026 / Gedung Kantor"
                  value={uploadTitle}
                  onChange={(e) => setUploadTitle(e.target.value)}
                  style={styles.input}
                />
              </div>

              {/* File Image Dropzone */}
              <div style={styles.formGroup}>
                <label style={styles.label}>Pilih File Gambar:</label>
                <input
                  type="file"
                  ref={uploadFileInputRef}
                  accept="image/jpeg,image/png,image/webp,image/jpg"
                  onChange={handleUploadFileSelect}
                  style={{ display: 'none' }}
                />

                <div
                  onClick={() => uploadFileInputRef.current?.click()}
                  style={styles.dropzone}
                >
                  {uploadPreviewUrl ? (
                    <div style={styles.previewBox}>
                      <img src={uploadPreviewUrl} alt="Preview" style={styles.previewImg} />
                      <span style={styles.changeFileText}>Klik untuk mengganti gambar</span>
                    </div>
                  ) : (
                    <div style={styles.dropzonePlaceholder}>
                      <svg width="42" height="42" viewBox="0 0 24 24" fill="none" stroke="#1e5a8a" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
                        <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                        <circle cx="8.5" cy="8.5" r="1.5" />
                        <polyline points="21 15 16 10 5 21" />
                      </svg>
                      <p style={styles.dropzoneTitle}>Klik untuk memilih foto dari komputer</p>
                      <span style={styles.dropzoneSubtitle}>Mendukung file JPG, PNG, WEBP (Maksimal 10MB)</span>
                    </div>
                  )}
                </div>
              </div>

              {/* Actions */}
              <div style={styles.modalActions}>
                <button
                  type="button"
                  onClick={handleCloseUploadModal}
                  style={styles.cancelBtn}
                  disabled={isSubmittingUpload}
                >
                  Batal
                </button>
                <button
                  type="submit"
                  style={styles.submitBtn}
                  disabled={isSubmittingUpload || !uploadFile}
                >
                  {isSubmittingUpload ? 'Mengunggah...' : 'Unggah Foto'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* ─── Modal 2: Edit Foto (Keterangan, Kategori, Ganti Gambar) ─── */}
      {isEditModalOpen && editingItem && (
        <div style={styles.modalBackdrop}>
          <div style={styles.modalCard}>
            <div style={styles.modalHeader}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                <div style={styles.modalHeaderIcon}>
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#1e5a8a" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                    <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                  </svg>
                </div>
                <h3 style={styles.modalTitle}>Edit Foto</h3>
              </div>
              <button onClick={handleCloseEditModal} style={styles.closeBtn}>✕</button>
            </div>

            <form onSubmit={handleEditSubmit} style={styles.modalBody}>
              {/* Kategori Radio */}
              <div style={styles.formGroup}>
                <label style={styles.label}>Bagian / Kategori:</label>
                <div style={{ display: 'flex', gap: 12 }}>
                  <label style={{ ...styles.radioLabel, ...(editCategory === 'galeri' ? styles.radioLabelActive : {}) }}>
                    <input
                      type="radio"
                      name="editCategory"
                      value="galeri"
                      checked={editCategory === 'galeri'}
                      onChange={() => setEditCategory('galeri')}
                      style={{ accentColor: '#1e5a8a' }}
                    />
                    Galeri Foto
                  </label>
                  <label style={{ ...styles.radioLabel, ...(editCategory === 'about' ? styles.radioLabelActive : {}) }}>
                    <input
                      type="radio"
                      name="editCategory"
                      value="about"
                      checked={editCategory === 'about'}
                      onChange={() => setEditCategory('about')}
                      style={{ accentColor: '#1e5a8a' }}
                    />
                    About Poca
                  </label>
                </div>
              </div>

              {/* Judul / Keterangan Input */}
              <div style={styles.formGroup}>
                <label style={styles.label}>Keterangan Foto (galleries.title):</label>
                <input
                  type="text"
                  placeholder="Keterangan foto..."
                  value={editTitle}
                  onChange={(e) => setEditTitle(e.target.value)}
                  style={styles.input}
                />
              </div>

              {/* Preview Gambar Saat Ini & Ganti Foto */}
              <div style={styles.formGroup}>
                <label style={styles.label}>Gambar Foto:</label>
                <input
                  type="file"
                  ref={editFileInputRef}
                  accept="image/jpeg,image/png,image/webp,image/jpg"
                  onChange={handleEditFileSelect}
                  style={{ display: 'none' }}
                />

                <div
                  onClick={() => editFileInputRef.current?.click()}
                  style={styles.dropzone}
                >
                  <div style={styles.previewBox}>
                    <img
                      src={editPreviewUrl || getImageUrl(editingItem.image_url)}
                      alt="Preview"
                      style={styles.previewImg}
                    />
                    <span style={styles.changeFileText}>
                      {editFile ? '✓ Gambar baru terpilih (Klik untuk ubah lagi)' : 'Klik di sini jika ingin mengganti file gambar'}
                    </span>
                  </div>
                </div>
              </div>

              {/* Actions */}
              <div style={styles.modalActions}>
                <button
                  type="button"
                  onClick={handleCloseEditModal}
                  style={styles.cancelBtn}
                  disabled={isSubmittingEdit}
                >
                  Batal
                </button>
                <button
                  type="submit"
                  style={styles.submitBtn}
                  disabled={isSubmittingEdit}
                >
                  {isSubmittingEdit ? 'Menyimpan...' : 'Simpan Perubahan'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* ─── Modal 3: Konfirmasi Hapus Foto ─── */}
      {deletingId && (
        <div style={styles.modalBackdrop}>
          <div style={{ ...styles.modalCard, maxWidth: 420, textAlign: 'center' }}>
            <div style={styles.deleteWarnIcon}>
              <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="#ef4444" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <polyline points="3 6 5 6 21 6" />
                <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" />
              </svg>
            </div>
            <h3 style={styles.deleteWarnTitle}>Hapus Foto Ini?</h3>
            <p style={styles.deleteWarnText}>
              Foto ini akan dihapus permanen dari server dan tidak akan tampil lagi di aplikasi mobile.
            </p>
            <div style={{ ...styles.modalActions, justifyContent: 'center' }}>
              <button
                type="button"
                onClick={() => setDeletingId(null)}
                style={styles.cancelBtn}
                disabled={isDeleting}
              >
                Batal
              </button>
              <button
                type="button"
                onClick={handleDelete}
                style={{ ...styles.submitBtn, background: '#ef4444' }}
                disabled={isDeleting}
              >
                {isDeleting ? 'Menghapus...' : 'Ya, Hapus'}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* ─── Lightbox Modal (Fullscreen Image) ─── */}
      {previewImage && (
        <div style={styles.lightboxBackdrop} onClick={() => setPreviewImage(null)}>
          <div style={styles.lightboxContent} onClick={(e) => e.stopPropagation()}>
            <button
              onClick={() => setPreviewImage(null)}
              style={styles.lightboxCloseBtn}
              title="Tutup Preview"
            >
              ✕
            </button>
            <img
              src={getImageUrl(previewImage.image_url)}
              alt={previewImage.title || 'Foto'}
              style={styles.lightboxImage}
            />
            {previewImage.title && (
              <div style={styles.lightboxCaption}>
                {previewImage.title}
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}

const styles = {
  wrapper: {
    minHeight: '100vh',
    background: '#dce6f0',
    fontFamily: "'DM Sans', 'Inter', -apple-system, BlinkMacSystemFont, sans-serif",
    display: 'flex',
    flexDirection: 'column',
  },
  header: {
    background: 'transparent',
    padding: '20px 32px',
    flexShrink: 0,
  },
  headerInner: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
    maxWidth: 1200,
    margin: '0 auto',
    width: '100%',
  },
  headerLeft: {
    display: 'flex',
    alignItems: 'center',
    gap: 14,
  },
  backBtn: {
    background: 'transparent',
    border: 'none',
    color: '#1e5a8a',
    cursor: 'pointer',
    padding: 8,
    borderRadius: 8,
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    transition: 'all 0.2s ease',
  },
  headerLogo: {
    width: 44,
    height: 44,
    borderRadius: 12,
    background: '#1e5a8a',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    boxShadow: '0 3px 10px rgba(30, 90, 138, 0.25)',
  },
  headerTitle: {
    fontSize: 16,
    fontWeight: 700,
    color: '#1a1a2e',
    margin: 0,
    letterSpacing: '-0.01em',
  },
  headerSubtitle: {
    fontSize: 12,
    color: '#8c9ab0',
    margin: 0,
    fontWeight: 400,
  },
  logoutBtn: {
    background: 'transparent',
    border: 'none',
    color: '#6b7a90',
    cursor: 'pointer',
    padding: 10,
    borderRadius: 10,
    display: 'flex',
    alignItems: 'center',
    transition: 'all 0.2s ease',
  },
  main: {
    flex: 1,
    padding: '0 32px 50px',
    maxWidth: 1200,
    margin: '0 auto',
    width: '100%',
    boxSizing: 'border-box',
  },
  toast: {
    position: 'fixed',
    top: 20,
    right: 20,
    zIndex: 99999,
    padding: '12px 18px',
    borderRadius: 12,
    fontSize: 14,
    fontWeight: 500,
    border: '1px solid transparent',
    boxShadow: '0 8px 24px rgba(0,0,0,0.12)',
    display: 'flex',
    alignItems: 'center',
    gap: 12,
  },
  toastClose: {
    background: 'transparent',
    border: 'none',
    color: 'inherit',
    cursor: 'pointer',
    fontWeight: 'bold',
  },
  titleRow: {
    marginBottom: 20,
  },
  titleLeft: {
    display: 'flex',
    alignItems: 'center',
    gap: 16,
  },
  titleIcon: {
    width: 48,
    height: 48,
    borderRadius: 14,
    background: '#ffffff',
    border: '1.5px solid #e8ecf1',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    boxShadow: '0 2px 8px rgba(0,0,0,0.03)',
  },
  pageTitle: {
    fontSize: 22,
    fontWeight: 700,
    color: '#1a1a2e',
    margin: 0,
    letterSpacing: '-0.02em',
  },
  pageSubtitle: {
    fontSize: 13,
    color: '#64748b',
    margin: '4px 0 0',
  },
  toolbar: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
    flexWrap: 'wrap',
    gap: 16,
    marginBottom: 20,
  },
  toolbarLeft: {
    display: 'flex',
    alignItems: 'center',
    gap: 14,
    flexWrap: 'wrap',
    flex: 1,
  },
  toolbarRight: {
    display: 'flex',
    alignItems: 'center',
  },
  searchBox: {
    position: 'relative',
    display: 'flex',
    alignItems: 'center',
    background: '#ffffff',
    borderRadius: 12,
    border: '1.5px solid #e2e8f0',
    padding: '0 12px',
    width: 280,
    boxShadow: '0 1px 4px rgba(0,0,0,0.02)',
  },
  searchIcon: {
    display: 'flex',
    alignItems: 'center',
    marginRight: 8,
  },
  searchInput: {
    border: 'none',
    outline: 'none',
    fontSize: 13,
    color: '#1e293b',
    padding: '9px 0',
    width: '100%',
    fontFamily: 'inherit',
  },
  clearSearchBtn: {
    background: 'transparent',
    border: 'none',
    color: '#94a3b8',
    cursor: 'pointer',
    fontSize: 12,
    padding: '2px 4px',
  },
  filterTabs: {
    display: 'flex',
    background: '#ffffff',
    padding: 3,
    borderRadius: 12,
    border: '1px solid #e2e8f0',
    boxShadow: '0 1px 4px rgba(0,0,0,0.02)',
  },
  tabBtn: {
    padding: '8px 18px',
    borderRadius: 9,
    border: 'none',
    background: 'transparent',
    fontSize: 13,
    fontWeight: 600,
    color: '#64748b',
    cursor: 'pointer',
    transition: 'all 0.2s',
  },
  tabBtnActive: {
    background: '#1e5a8a',
    color: '#ffffff',
    boxShadow: '0 2px 8px rgba(30, 90, 138, 0.25)',
  },
  primaryBtn: {
    display: 'flex',
    alignItems: 'center',
    gap: 8,
    background: '#1e5a8a',
    color: '#ffffff',
    border: 'none',
    padding: '10px 18px',
    borderRadius: 12,
    fontSize: 13.5,
    fontWeight: 600,
    cursor: 'pointer',
    boxShadow: '0 3px 10px rgba(30, 90, 138, 0.25)',
    transition: 'all 0.2s',
  },
  contentContainer: {
    background: '#ffffff',
    borderRadius: 20,
    border: '1px solid #e2e8f0',
    padding: 24,
    boxShadow: '0 4px 20px rgba(0,0,0,0.04)',
    display: 'flex',
    flexDirection: 'column',
    minHeight: 450,
  },
  loadingBox: {
    padding: '80px 0',
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'center',
    margin: 'auto',
  },
  emptyBox: {
    padding: '60px 20px',
    textAlign: 'center',
    margin: 'auto',
  },
  emptyIconCircle: {
    width: 68,
    height: 68,
    borderRadius: 34,
    background: '#f1f5f9',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    margin: '0 auto 16px',
  },
  emptyTitle: {
    fontSize: 17,
    fontWeight: 700,
    color: '#1e293b',
    margin: '0 0 6px',
  },
  emptySubtitle: {
    fontSize: 13,
    color: '#64748b',
    margin: 0,
  },
  grid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fill, minmax(250px, 1fr))',
    gap: 20,
    marginBottom: 20,
  },
  photoCard: {
    background: '#ffffff',
    borderRadius: 16,
    overflow: 'hidden',
    border: '1.5px solid #edf2f7',
    boxShadow: '0 2px 10px rgba(0,0,0,0.03)',
    display: 'flex',
    flexDirection: 'column',
    transition: 'all 0.25s ease',
  },
  cardImageWrapper: {
    position: 'relative',
    height: 180,
    cursor: 'pointer',
    overflow: 'hidden',
    background: '#f8fafc',
  },
  cardImage: {
    width: '100%',
    height: '100%',
    objectFit: 'cover',
    display: 'block',
    transition: 'transform 0.3s ease',
  },
  imageOverlay: {
    position: 'absolute',
    inset: 0,
    background: 'rgba(15, 23, 42, 0.45)',
    opacity: 0,
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    transition: 'opacity 0.2s ease',
  },
  overlayText: {
    color: '#ffffff',
    fontSize: 12,
    fontWeight: 600,
    display: 'flex',
    alignItems: 'center',
    gap: 6,
    background: 'rgba(0,0,0,0.6)',
    padding: '6px 12px',
    borderRadius: 20,
    backdropFilter: 'blur(4px)',
  },
  cardBody: {
    padding: '14px 16px',
    display: 'flex',
    flexDirection: 'column',
    gap: 12,
    flex: 1,
  },
  cardTitleRow: {
    display: 'flex',
    alignItems: 'flex-start',
    justifyContent: 'space-between',
    gap: 8,
  },
  cardTitle: {
    fontSize: 14.5,
    fontWeight: 700,
    color: '#0f172a',
    margin: 0,
    lineHeight: 1.35,
    flex: 1,
    display: '-webkit-box',
    WebkitLineClamp: 2,
    WebkitBoxOrient: 'vertical',
    overflow: 'hidden',
  },
  badge: {
    fontSize: 10.5,
    fontWeight: 600,
    padding: '3px 8px',
    borderRadius: 6,
    whiteSpace: 'nowrap',
  },
  cardFooter: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingTop: 10,
    borderTop: '1px solid #f1f5f9',
    marginTop: 'auto',
  },
  dateText: {
    fontSize: 12,
    color: '#94a3b8',
  },
  cardActions: {
    display: 'flex',
    alignItems: 'center',
    gap: 6,
  },
  editBtn: {
    display: 'flex',
    alignItems: 'center',
    gap: 4,
    background: '#f0f9ff',
    border: '1px solid #bae6fd',
    color: '#0284c7',
    fontSize: 12,
    fontWeight: 600,
    cursor: 'pointer',
    padding: '4px 10px',
    borderRadius: 7,
    transition: 'all 0.2s',
  },
  deleteBtn: {
    display: 'flex',
    alignItems: 'center',
    gap: 4,
    background: '#fef2f2',
    border: '1px solid #fecaca',
    color: '#ef4444',
    fontSize: 12,
    fontWeight: 600,
    cursor: 'pointer',
    padding: '4px 10px',
    borderRadius: 7,
    transition: 'all 0.2s',
  },
  footerInfo: {
    marginTop: 'auto',
    paddingTop: 16,
    borderTop: '1px solid #f1f5f9',
    fontSize: 13,
    color: '#64748b',
  },
  modalBackdrop: {
    position: 'fixed',
    inset: 0,
    background: 'rgba(15, 23, 42, 0.55)',
    backdropFilter: 'blur(4px)',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    zIndex: 9999,
    padding: 20,
  },
  modalCard: {
    background: '#ffffff',
    borderRadius: 20,
    width: '100%',
    maxWidth: 500,
    overflow: 'hidden',
    boxShadow: '0 20px 40px rgba(0,0,0,0.2)',
  },
  modalHeader: {
    padding: '18px 24px',
    borderBottom: '1px solid #f1f5f9',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  modalHeaderIcon: {
    width: 36,
    height: 36,
    borderRadius: 10,
    background: '#e0f2fe',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
  },
  modalTitle: {
    fontSize: 16.5,
    fontWeight: 700,
    color: '#0f172a',
    margin: 0,
  },
  closeBtn: {
    background: 'transparent',
    border: 'none',
    fontSize: 18,
    color: '#94a3b8',
    cursor: 'pointer',
  },
  modalBody: {
    padding: '20px 24px',
    display: 'flex',
    flexDirection: 'column',
    gap: 18,
  },
  formGroup: {
    display: 'flex',
    flexDirection: 'column',
    gap: 8,
  },
  label: {
    fontSize: 13,
    fontWeight: 600,
    color: '#334155',
  },
  input: {
    padding: '10px 14px',
    borderRadius: 10,
    border: '1.5px solid #e2e8f0',
    fontSize: 13.5,
    outline: 'none',
    fontFamily: 'inherit',
    transition: 'border 0.2s',
  },
  radioLabel: {
    display: 'flex',
    alignItems: 'center',
    gap: 8,
    padding: '9px 14px',
    borderRadius: 9,
    border: '1.5px solid #e2e8f0',
    fontSize: 13,
    fontWeight: 500,
    cursor: 'pointer',
    flex: 1,
  },
  radioLabelActive: {
    borderColor: '#1e5a8a',
    background: '#f0f7ff',
    color: '#1e5a8a',
    fontWeight: 600,
  },
  dropzone: {
    border: '2px dashed #cbd5e1',
    borderRadius: 14,
    padding: 16,
    textAlign: 'center',
    cursor: 'pointer',
    background: '#f8fafc',
    transition: 'all 0.2s',
  },
  dropzonePlaceholder: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    gap: 8,
    padding: '16px 10px',
  },
  dropzoneTitle: {
    fontSize: 13.5,
    fontWeight: 600,
    color: '#1e293b',
    margin: 0,
  },
  dropzoneSubtitle: {
    fontSize: 12,
    color: '#94a3b8',
  },
  previewBox: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    gap: 8,
  },
  previewImg: {
    maxHeight: 160,
    maxWidth: '100%',
    borderRadius: 8,
    objectFit: 'contain',
    boxShadow: '0 2px 8px rgba(0,0,0,0.08)',
  },
  changeFileText: {
    fontSize: 12,
    color: '#1e5a8a',
    fontWeight: 600,
  },
  modalActions: {
    display: 'flex',
    gap: 12,
    justifyContent: 'flex-end',
    marginTop: 8,
  },
  cancelBtn: {
    padding: '10px 18px',
    borderRadius: 10,
    border: '1px solid #e2e8f0',
    background: '#fff',
    color: '#64748b',
    fontSize: 13.5,
    fontWeight: 600,
    cursor: 'pointer',
  },
  submitBtn: {
    padding: '10px 22px',
    borderRadius: 10,
    border: 'none',
    background: '#1e5a8a',
    color: '#fff',
    fontSize: 13.5,
    fontWeight: 600,
    cursor: 'pointer',
    boxShadow: '0 2px 8px rgba(30,90,138,0.25)',
  },
  deleteWarnIcon: {
    width: 60,
    height: 60,
    borderRadius: 30,
    background: '#fee2e2',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    margin: '0 auto 14px',
  },
  deleteWarnTitle: {
    fontSize: 17,
    fontWeight: 700,
    color: '#0f172a',
    margin: '0 0 8px',
  },
  deleteWarnText: {
    fontSize: 13,
    color: '#64748b',
    lineHeight: 1.5,
    margin: '0 0 20px',
  },
  lightboxBackdrop: {
    position: 'fixed',
    inset: 0,
    background: 'rgba(0, 0, 0, 0.88)',
    backdropFilter: 'blur(8px)',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    zIndex: 99999,
    padding: 24,
  },
  lightboxContent: {
    position: 'relative',
    maxWidth: '90vw',
    maxHeight: '90vh',
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
  },
  lightboxCloseBtn: {
    position: 'absolute',
    top: -44,
    right: 0,
    background: 'rgba(255,255,255,0.2)',
    border: 'none',
    color: '#ffffff',
    fontSize: 20,
    width: 36,
    height: 36,
    borderRadius: 18,
    cursor: 'pointer',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
  },
  lightboxImage: {
    maxWidth: '100%',
    maxHeight: '80vh',
    borderRadius: 12,
    objectFit: 'contain',
    boxShadow: '0 10px 40px rgba(0,0,0,0.5)',
  },
  lightboxCaption: {
    color: '#ffffff',
    fontSize: 15,
    fontWeight: 500,
    marginTop: 12,
    textAlign: 'center',
  },
};
