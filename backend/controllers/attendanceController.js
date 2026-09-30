const path = require('path');
const fs = require('fs');
const axios = require('axios');
const FormData = require('form-data');
const Attendance = require('../models/Attendance');
const User = require('../models/User');
const Location = require('../models/Location');
const haversine = require('../utils/haversine');

// URL Microservice AI Face Recognition (self-hosted)
const AI_SERVICE_URL = process.env.AI_SERVICE_URL || 'http://127.0.0.1:8000';

/**
 * AttendanceController - Menangani seluruh logika absensi.
 */
const attendanceController = {
  // ════════════════════════════════════════════════════════════════
  // POST /api/attendance/clock-in
  // Proses Clock In: geofencing → face recognition via AI → simpan log
  //
  // Flow:
  //   1. Ambil user_id, latitude, longitude, location_id dari body & file foto dari Multer
  //   2. Ambil data lokasi dari tabel locations berdasarkan location_id
  //   3. Hitung jarak Haversine → jika > radius → INSERT "Di Luar Radius"
  //   4. Ambil face_photo master dari tabel users
  //   5. Kirim captured_image + master_image ke AI service /compare
  //   6. Jika AI gagal deteksi wajah → INSERT "Gagal Verifikasi Wajah"
  //   7. Jika verified = false → INSERT "Wajah Tidak Cocok"
  //   8. Jika lolos → INSERT "Clock In" dengan distance, confidence, dsb.
  // ════════════════════════════════════════════════════════════════
  clockIn: async (req, res, next) => {
    try {
      const userId = req.user.id;

      // ──────────────────────────────────────────────
      // 1. Ambil data dari request
      // ──────────────────────────────────────────────
      const { latitude, longitude, location_id } = req.body;

      if (!req.file) {
        return res.status(400).json({
          success: false,
          message: 'Foto wajah wajib diunggah saat Clock In.',
        });
      }

      if (!latitude || !longitude) {
        fs.unlinkSync(req.file.path);
        return res.status(400).json({
          success: false,
          message: 'Latitude dan longitude wajib disertakan.',
        });
      }

      if (!location_id) {
        fs.unlinkSync(req.file.path);
        return res.status(400).json({
          success: false,
          message: 'Location ID wajib disertakan.',
        });
      }

      const lat = parseFloat(latitude);
      const lng = parseFloat(longitude);
      const locId = parseInt(location_id, 10);

      if (isNaN(lat) || isNaN(lng)) {
        fs.unlinkSync(req.file.path);
        return res.status(400).json({
          success: false,
          message: 'Latitude dan longitude harus berupa angka yang valid.',
        });
      }

      const photoRelativePath = `attendance/${req.file.filename}`;

      // ──────────────────────────────────────────────
      // 2. Ambil data lokasi dari tabel locations
      // ──────────────────────────────────────────────
      const location = await Location.findById(locId);

      if (!location) {
        fs.unlinkSync(req.file.path);
        return res.status(404).json({
          success: false,
          message: 'Lokasi tidak ditemukan. Hubungi admin.',
        });
      }

      // ──────────────────────────────────────────────
      // 3. Hitung jarak Haversine
      // ──────────────────────────────────────────────
      const distance = haversine(lat, lng, location.latitude, location.longitude);
      const radius = location.radius || parseInt(process.env.DEFAULT_RADIUS_METERS, 10) || 100;

      // ──────────────────────────────────────────────
      // 3a. Jika di luar radius → simpan log & return error
      // ──────────────────────────────────────────────
      if (distance > radius) {
        const attendanceLog = await Attendance.create({
          user_id: userId,
          latitude: lat,
          longitude: lng,
          distance,
          face_confidence: null,
          status: 'Di Luar Radius',
          photo: photoRelativePath,
          location_id: locId,
        });

        return res.status(400).json({
          success: false,
          message: `Anda berada di luar radius. Jarak Anda: ${distance} meter, radius maksimum: ${radius} meter.`,
          data: {
            id: attendanceLog.id,
            status: 'Di Luar Radius',
            distance,
            radius,
            timestamp: new Date().toISOString(),
          },
        });
      }

      // ──────────────────────────────────────────────
      // 4. Ambil foto master wajah dari tabel users
      // ──────────────────────────────────────────────
      const facePhoto = await User.getFacePhoto(userId);

      if (!facePhoto) {
        fs.unlinkSync(req.file.path);
        return res.status(400).json({
          success: false,
          message: 'Foto master wajah belum terdaftar. Hubungi admin untuk mendaftarkan foto wajah Anda.',
        });
      }

      // Path absolut ke foto master (disimpan di uploads/<face_photo>)
      const masterPhotoPath = path.join(__dirname, '..', 'uploads', facePhoto);

      if (!fs.existsSync(masterPhotoPath)) {
        fs.unlinkSync(req.file.path);
        return res.status(400).json({
          success: false,
          message: 'File foto master wajah tidak ditemukan di server. Hubungi admin.',
        });
      }

      // ──────────────────────────────────────────────
      // 5. Kirim ke Microservice AI untuk verifikasi wajah
      // ──────────────────────────────────────────────
      let aiResult;

      try {
        const formData = new FormData();
        formData.append('captured_image', fs.createReadStream(req.file.path));
        formData.append('master_image', fs.createReadStream(masterPhotoPath));

        const aiResponse = await axios.post(`${AI_SERVICE_URL}/compare`, formData, {
          headers: {
            ...formData.getHeaders(),
          },
          timeout: 60000, // 60 detik timeout (model inference bisa lambat)
          // Terima semua status code agar kita bisa handle response 400 dari AI
          validateStatus: (status) => status < 500,
        });

        aiResult = aiResponse.data;
      } catch (aiError) {
        // ──────────────────────────────────────────────
        // 6. Jika AI service tidak bisa dihubungi / error
        // ──────────────────────────────────────────────
        console.error('❌ Gagal menghubungi AI Service:', aiError.message);

        const attendanceLog = await Attendance.create({
          user_id: userId,
          latitude: lat,
          longitude: lng,
          distance,
          face_confidence: null,
          status: 'Gagal Verifikasi Wajah',
          photo: photoRelativePath,
          location_id: locId,
        });

        return res.status(500).json({
          success: false,
          message: 'Gagal menghubungi layanan verifikasi wajah. Silakan coba lagi.',
          data: {
            id: attendanceLog.id,
            status: 'Gagal Verifikasi Wajah',
            timestamp: new Date().toISOString(),
          },
        });
      }

      // ──────────────────────────────────────────────
      // 6. Jika AI gagal mendeteksi wajah pada foto
      // ──────────────────────────────────────────────
      if (!aiResult.success) {
        const attendanceLog = await Attendance.create({
          user_id: userId,
          latitude: lat,
          longitude: lng,
          distance,
          face_confidence: null,
          status: 'Gagal Verifikasi Wajah',
          photo: photoRelativePath,
          location_id: locId,
        });

        return res.status(400).json({
          success: false,
          message: aiResult.error || 'Gagal memverifikasi wajah. Pastikan foto menampilkan wajah dengan jelas.',
          data: {
            id: attendanceLog.id,
            status: 'Gagal Verifikasi Wajah',
            timestamp: new Date().toISOString(),
          },
        });
      }

      // ──────────────────────────────────────────────
      // 7. Jika wajah tidak cocok (verified = false)
      // ──────────────────────────────────────────────
      if (!aiResult.verified) {
        const attendanceLog = await Attendance.create({
          user_id: userId,
          latitude: lat,
          longitude: lng,
          distance,
          face_confidence: aiResult.confidence,
          status: 'Wajah Tidak Cocok',
          photo: photoRelativePath,
          location_id: locId,
        });

        return res.status(400).json({
          success: false,
          message: `Wajah tidak cocok. Confidence: ${aiResult.confidence}%.`,
          data: {
            id: attendanceLog.id,
            status: 'Wajah Tidak Cocok',
            face_confidence: aiResult.confidence,
            distance,
            timestamp: new Date().toISOString(),
          },
        });
      }

      // ──────────────────────────────────────────────
      // 8. Lolos verifikasi → simpan sebagai Clock In
      // ──────────────────────────────────────────────
      const attendanceLog = await Attendance.create({
        user_id: userId,
        latitude: lat,
        longitude: lng,
        distance,
        face_confidence: aiResult.confidence,
        status: 'Clock In',
        photo: photoRelativePath,
        location_id: locId,
      });

      const now = new Date();
      const timeStr = now
        .toLocaleTimeString('id-ID', {
          hour: '2-digit',
          minute: '2-digit',
          timeZone: 'Asia/Jakarta',
        })
        .replace('.', ':');

      return res.status(200).json({
        success: true,
        message: `Clock In berhasil pada pukul ${timeStr}.`,
        data: {
          id: attendanceLog.id,
          status: 'Clock In',
          time: timeStr,
          distance,
          radius,
          face_confidence: aiResult.confidence,
          photo: photoRelativePath,
          location: location.name,
          timestamp: now.toISOString(),
        },
      });
    } catch (error) {
      // Cleanup file jika terjadi error tak terduga
      if (req.file && fs.existsSync(req.file.path)) {
        fs.unlinkSync(req.file.path);
      }
      next(error);
    }
  },

  /**
   * POST /api/attendance
   * Proses absensi legacy: upload foto, geofencing, face recognition, simpan log.
   *
   * Flow:
   *   1. Validasi JWT (sudah dilakukan oleh authMiddleware)
   *   2. Validasi koordinat (latitude & longitude)
   *   3. Ambil lokasi kantor/kampus dari database
   *   4. Hitung jarak menggunakan Haversine
   *   5. Jika di luar radius → status "Di Luar Radius"
   *   6. Jika dalam radius → bandingkan wajah dengan foto master
   *   7. Jika wajah cocok → status "Hadir"
   *   8. Jika tidak cocok → status "Wajah Tidak Cocok"
   *   9. Simpan log absensi
   */
  submitAttendance: async (req, res, next) => {
    try {
      const userId = req.user.id;

      // ──────────────────────────────────────────────
      // 1. Validasi tipe absensi ('in' atau 'out')
      // ──────────────────────────────────────────────
      const type = (req.body.type || 'in').toLowerCase();
      if (!['in', 'out'].includes(type)) {
        if (req.file) fs.unlinkSync(req.file.path);
        return res.status(400).json({
          success: false,
          message: 'Tipe presensi tidak valid. Harus "in" (Clock In) atau "out" (Clock Out).',
        });
      }

      // ──────────────────────────────────────────────
      // 2. Validasi Aturan Harian (1x per hari per aksi)
      // ──────────────────────────────────────────────
      const todayStatus = await Attendance.getTodayStatus(userId);

      if (type === 'in' && todayStatus.hasClockedIn) {
        if (req.file) fs.unlinkSync(req.file.path);
        const inTime = (todayStatus.clockIn.time || (todayStatus.clockIn.time || new Date(todayStatus.clockIn.created_at).toLocaleTimeString('id-ID', {
          hour: '2-digit',
          minute: '2-digit',
          timeZone: 'Asia/Jakarta',
          timeZone: 'Asia/Jakarta',
        })).replace('.', ':')).replace('.', ':');
        return res.status(400).json({
          success: false,
          message: `Anda sudah melakukan Clock In hari ini pada pukul ${inTime}.`,
        });
      }

      if (type === 'out') {
        if (!todayStatus.hasClockedIn) {
          if (req.file) fs.unlinkSync(req.file.path);
          return res.status(400).json({
            success: false,
            message: 'Anda belum melakukan Clock In hari ini. Silakan Clock In terlebih dahulu.',
          });
        }
        if (todayStatus.hasClockedOut) {
          if (req.file) fs.unlinkSync(req.file.path);
          const outTime = (todayStatus.clockOut.time || (todayStatus.clockOut.time || new Date(todayStatus.clockOut.created_at).toLocaleTimeString('id-ID', {
            hour: '2-digit',
            minute: '2-digit',
            timeZone: 'Asia/Jakarta',
            timeZone: 'Asia/Jakarta',
          })).replace('.', ':')).replace('.', ':');
          return res.status(400).json({
            success: false,
            message: `Anda sudah melakukan Clock Out hari ini pada pukul ${outTime}.`,
          });
        }
      }

      // ──────────────────────────────────────────────
      // 3. Validasi file foto (Wajib hanya untuk Clock In, Clock Out tanpa foto)
      // 3. Validasi file foto (Wajib hanya untuk Clock In, Clock Out tanpa foto)
      // ──────────────────────────────────────────────
      if (type === 'in' && type === 'in' && !req.file) {
        return res.status(400).json({
          success: false,
          message: 'Foto identifikasi identifikasi wajah wajib diunggah saat Clock In saat Clock In.',
        });
      }

      // ──────────────────────────────────────────────
      // 4. Validasi koordinat GPS
      // ──────────────────────────────────────────────
      const { latitude, longitude } = req.body;

      if (!latitude || !longitude) {
        if (req.file) fs.unlinkSync(req.file.path);
        return res.status(400).json({
          success: false,
          message: 'Latitude dan longitude wajib disertakan.',
        });
      }

      const lat = parseFloat(latitude);
      const lng = parseFloat(longitude);

      if (isNaN(lat) || isNaN(lng)) {
        if (req.file) fs.unlinkSync(req.file.path);
        return res.status(400).json({
          success: false,
          message: 'Latitude dan longitude harus berupa angka yang valid.',
        });
      }

      if (lat < -90 || lat > 90 || lng < -180 || lng > 180) {
        if (req.file) fs.unlinkSync(req.file.path);
        return res.status(400).json({
          success: false,
          message: 'Koordinat di luar rentang valid. Latitude: -90 s/d 90, Longitude: -180 s/d 180.',
        });
      }

      // ──────────────────────────────────────────────
      // 5. Ambil lokasi kantor/kampus dari database
      // ──────────────────────────────────────────────
      let location = await Location.getActive();
      const allLocations = await Location.findAll();

      if (!location) {
        if (req.file) fs.unlinkSync(req.file.path);
        return res.status(404).json({
          success: false,
          message: 'Lokasi kantor/kampus belum dikonfigurasi. Hubungi admin.',
        });
      }

      // ──────────────────────────────────────────────
      // 6. Hitung jarak menggunakan Haversine
      // ──────────────────────────────────────────────
      const distance = haversine(lat, lng, location.latitude, location.longitude);
      const radius = location.radius || parseInt(process.env.DEFAULT_RADIUS_METERS, 10) || 100;

      // ──────────────────────────────────────────────
      // 7. Cek geofencing - Jika di luar radius
      // ──────────────────────────────────────────────
      if (distance > radius) {
        // Simpan log dengan status "Di Luar Radius"
        const photoRelativePath = req.file ? `attendance/${req.file.filename}` : null;

        const attendanceLog = await Attendance.create({
          user_id: userId,
          latitude: lat,
          longitude: lng,
          distance,
          face_confidence: null,
          status: 'Di Luar Radius',
          photo: photoRelativePath,
          location_id: location.id,
        });

        return res.status(200).json({
          success: false,
          message: `Anda berada di luar radius. Jarak Anda: ${distance} meter, radius maksimum: ${radius} meter.`,
          data: {
            id: attendanceLog.id,
            status: 'Di Luar Radius',
            distance,
            radius,
            timestamp: new Date().toISOString(),
          },
        });
      }

      // ──────────────────────────────────────────────
      // 6. Face Recognition via AI Microservice (Clock In only)
      // ──────────────────────────────────────────────
      let faceConfidence = null;
      let faceStatus = type === 'out' ? 'Clock Out' : 'Clock In';

      if (type === 'in') {
        // Ambil foto master
        const facePhoto = await User.getFacePhoto(userId);

        if (!facePhoto) {
          if (req.file) fs.unlinkSync(req.file.path);
          return res.status(400).json({
            success: false,
            message: 'Foto master wajah belum terdaftar. Hubungi admin.',
          });
        }

        const masterPhotoPath = path.join(__dirname, '..', 'uploads', facePhoto);

        if (!fs.existsSync(masterPhotoPath)) {
          if (req.file) fs.unlinkSync(req.file.path);
          return res.status(400).json({
            success: false,
            message: 'File foto master wajah tidak ditemukan di server. Hubungi admin.',
          });
        }

        try {
          const formData = new FormData();
          formData.append('captured_image', fs.createReadStream(req.file.path));
          formData.append('master_image', fs.createReadStream(masterPhotoPath));

          const aiResponse = await axios.post(`${AI_SERVICE_URL}/compare`, formData, {
            headers: { ...formData.getHeaders() },
            timeout: 60000,
            validateStatus: (status) => status < 500,
          });

          const aiResult = aiResponse.data;

          if (!aiResult.success) {
            // Wajah tidak terdeteksi
            const photoRelativePath = `attendance/${req.file.filename}`;
            const attendanceLog = await Attendance.create({
              user_id: userId,
              latitude: lat,
              longitude: lng,
              distance,
              face_confidence: null,
              status: 'Gagal Verifikasi Wajah',
              photo: photoRelativePath,
              location_id: location.id,
            });

            return res.status(400).json({
              success: false,
              message: aiResult.error || 'Gagal mendeteksi wajah pada foto. Pastikan wajah terlihat jelas.',
              data: {
                id: attendanceLog.id,
                status: 'Gagal Verifikasi Wajah',
                timestamp: new Date().toISOString(),
              },
            });
          }

          if (!aiResult.verified) {
            // Wajah tidak cocok
            const photoRelativePath = `attendance/${req.file.filename}`;
            const attendanceLog = await Attendance.create({
              user_id: userId,
              latitude: lat,
              longitude: lng,
              distance,
              face_confidence: aiResult.confidence,
              status: 'Wajah Tidak Cocok',
              photo: photoRelativePath,
              location_id: location.id,
            });

            return res.status(400).json({
              success: false,
              message: `Wajah tidak cocok dengan foto profil pendaftaran (Kecocokan: ${aiResult.confidence}%). Presensi ditolak.`,
              data: {
                id: attendanceLog.id,
                status: 'Wajah Tidak Cocok',
                face_confidence: aiResult.confidence,
                distance,
                timestamp: new Date().toISOString(),
              },
            });
          }

          // Verifikasi berhasil
          faceConfidence = aiResult.confidence;
          faceStatus = 'Clock In';
        } catch (aiError) {
          console.error('❌ Gagal menghubungi AI Service:', aiError.message);

          const photoRelativePath = `attendance/${req.file.filename}`;
          const attendanceLog = await Attendance.create({
            user_id: userId,
            latitude: lat,
            longitude: lng,
            distance,
            face_confidence: null,
            status: 'Gagal Verifikasi Wajah',
            photo: photoRelativePath,
            location_id: location.id,
          });

          return res.status(500).json({
            success: false,
            message: 'Gagal menghubungi layanan verifikasi wajah. Silakan coba lagi.',
            data: {
              id: attendanceLog.id,
              status: 'Gagal Verifikasi Wajah',
              timestamp: new Date().toISOString(),
            },
          });
        }
      }

      // ──────────────────────────────────────────────
      // 7. Simpan log absensi dengan status final
      // ──────────────────────────────────────────────
      const photoRelativePath = req.file ? `attendance/${req.file.filename}` : null;

      const attendanceLog = await Attendance.create({
        user_id: userId,
        latitude: lat,
        longitude: lng,
        distance,
        face_confidence: faceConfidence,
        status: faceStatus,
        photo: photoRelativePath,
        location_id: location.id,
      });

      // ──────────────────────────────────────────────
      // 10. Response
      // ──────────────────────────────────────────────
      const isSuccess = faceStatus === 'Clock In' || faceStatus === 'Clock Out';
      const statusCode = 200;
      const actionLabel = type === 'in' ? 'Clock In' : 'Clock Out';
      const now = new Date();
      const timeStr = now.toLocaleTimeString('id-ID', {
        hour: '2-digit',
        minute: '2-digit',
        timeZone: 'Asia/Jakarta',
      }).replace('.', ':');

      return res.status(statusCode).json({
        success: isSuccess,
        message: isSuccess
          ? `${actionLabel} berhasil pada pukul ${timeStr}.`
          : `${actionLabel} gagal. Wajah tidak cocok (confidence: ${faceConfidence}%).`,
        data: {
          id: attendanceLog.id,
          status: faceStatus,
          time: timeStr,
          distance,
          radius,
          face_confidence: faceConfidence,
          photo: photoRelativePath,
          location: location.name,
          timestamp: now.toISOString(),
        },
      });
    } catch (error) {
      // Cleanup file jika terjadi error
      if (req.file && fs.existsSync(req.file.path)) {
        fs.unlinkSync(req.file.path);
      }
      next(error);
    }
  },

  /**
   * GET /api/attendance/history
   * Ambil riwayat absensi user yang sedang login.
   */
  getMyHistory: async (req, res, next) => {
    try {
      const userId = req.user.id;
      const page = parseInt(req.query.page, 10) || 1;
      const limit = parseInt(req.query.limit, 10) || 20;

      const result = await Attendance.findByUserId(userId, { page, limit });

      return res.status(200).json({
        success: true,
        message: 'Riwayat absensi berhasil diambil.',
        data: result.data,
        pagination: {
          total: result.total,
          page: result.page,
          totalPages: result.totalPages,
          limit,
        },
      });
    } catch (error) {
      next(error);
    }
  },

  /**
   * GET /api/attendance
   * Ambil semua log absensi (admin only).
   * Query params: page, limit, user_id, status, date_from, date_to
   */
  getAllAttendance: async (req, res, next) => {
    try {
      const { page, limit, user_id, status, date_from, date_to, location_id } = req.query;

      const result = await Attendance.findAll({
        page: parseInt(page, 10) || 1,
        limit: parseInt(limit, 10) || 20,
        user_id: user_id ? parseInt(user_id, 10) : undefined,
        status,
        date_from,
        date_to,
        location_id: location_id ? parseInt(location_id, 10) : undefined,
      });

      return res.status(200).json({
        success: true,
        message: 'Data absensi berhasil diambil.',
        data: result.data,
        pagination: {
          total: result.total,
          page: result.page,
          totalPages: result.totalPages,
          limit: parseInt(limit, 10) || 20,
        },
      });
    } catch (error) {
      next(error);
    }
  },

  /**
   * GET /api/attendance/:id
   * Ambil detail absensi berdasarkan ID.
   */
  getAttendanceById: async (req, res, next) => {
    try {
      const { id } = req.params;
      const attendance = await Attendance.findById(parseInt(id, 10));

      if (!attendance) {
        return res.status(404).json({
          success: false,
          message: 'Data absensi tidak ditemukan.',
        });
      }

      // User biasa hanya bisa lihat absensinya sendiri
      if (req.user.role !== 'admin' && attendance.user_id !== req.user.id) {
        return res.status(403).json({
          success: false,
          message: 'Anda tidak memiliki akses ke data absensi ini.',
        });
      }

      return res.status(200).json({
        success: true,
        message: 'Detail absensi berhasil diambil.',
        data: attendance,
      });
    } catch (error) {
      next(error);
    }
  },

  getTodayStatus: async (req, res, next) => {
    try {
      const userId = req.user.id;
      const status = await Attendance.getTodayStatus(userId);
      return res.status(200).json({
        success: true,
        data: status,
      });
    } catch (error) {
      next(error);
    }
  },

  /**
   * PATCH /api/attendance/:id/status
   * Update status verifikasi kehadiran / face approval (admin only).
   */
  updateStatus: async (req, res, next) => {
    try {
      const { id } = req.params;
      const { status, notes } = req.body;

      if (!status) {
        return res.status(400).json({
          success: false,
          message: 'Status wajib diisi.',
        });
      }

      await Attendance.updateStatus(parseInt(id, 10), { status, notes });

      return res.status(200).json({
        success: true,
        message: 'Status absensi berhasil diperbarui.',
      });
    } catch (error) {
      next(error);
    }
  },

  /**
   * PATCH /api/attendance/:id/status
   * Update status verifikasi kehadiran / face approval (admin only).
   */
  updateStatus: async (req, res, next) => {
    try {
      const { id } = req.params;
      const { status, notes } = req.body;

      if (!status) {
        return res.status(400).json({
          success: false,
          message: 'Status wajib diisi.',
        });
      }

      await Attendance.updateStatus(parseInt(id, 10), { status, notes });

      return res.status(200).json({
        success: true,
        message: 'Status absensi berhasil diperbarui.',
      });
    } catch (error) {
      next(error);
    }
  },
};

module.exports = attendanceController;
