-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Sep 29, 2026 at 07:58 AM
-- Server version: 8.0.30
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `absensi_db`
--
CREATE DATABASE IF NOT EXISTS `absensi_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `absensi_db`;

-- --------------------------------------------------------

--
-- Table structure for table `attendance_logs`
--

CREATE TABLE `attendance_logs` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `latitude` double NOT NULL COMMENT 'Latitude lokasi user saat absensi',
  `longitude` double NOT NULL COMMENT 'Longitude lokasi user saat absensi',
  `distance` double DEFAULT NULL COMMENT 'Jarak ke lokasi kantor (meter)',
  `face_confidence` double DEFAULT NULL COMMENT 'Confidence score face comparison (0-100)',
  `status` enum('Clock In','Clock Out','Di Luar Radius','Wajah Tidak Cocok','Gagal Verifikasi Wajah','Izin') COLLATE utf8mb4_unicode_ci NOT NULL,
  `photo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Path relatif ke foto absensi',
  `notes` text COLLATE utf8mb4_unicode_ci COMMENT 'Catatan admin untuk verifikasi atau alasan absensi',
  `location_id` int DEFAULT NULL COMMENT 'Lokasi kantor/kampus yang digunakan saat absensi',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `attendance_logs`
--

INSERT INTO `attendance_logs` (`id`, `user_id`, `latitude`, `longitude`, `distance`, `face_confidence`, `status`, `photo`, `notes`, `location_id`, `created_at`) VALUES
(1, 3, -7.3249898, 112.7216887, 8.58, 100, 'Clock In', 'attendance/1790322525174-01336ec6e50018580add03a7d989322f.jpg', NULL, 1, '2026-09-25 07:48:45'),
(2, 3, -7.3249976, 112.7216761, 7.72, 100, 'Clock Out', 'attendance/1790322762660-333da6895d4c652e9cda6c08efd9821d.jpg', NULL, 1, '2026-09-25 07:52:42'),
(3, 4, -7.3254605, 112.72173, 44.1, 100, 'Clock In', 'attendance/1790323844456-22c85715538f273a73d29f617e21910f.jpg', NULL, 1, '2026-09-25 08:10:44'),
(6, 4, -7.4107333, 112.6271117, 14124.51, NULL, 'Di Luar Radius', 'attendance/1790403670290-276046736632758415987742952ef7e9.jpg', NULL, 1, '2026-09-26 06:21:10'),
(7, 4, -7.4106533, 112.62724, 28.97, NULL, 'Gagal Verifikasi Wajah', 'attendance/1790403981962-741d1a5e40a9fc8264dcc7dec43751ff.jpg', NULL, 1, '2026-09-26 06:26:52'),
(8, 4, -7.4106116, 112.6272199, 24.93, NULL, 'Gagal Verifikasi Wajah', 'attendance/1790404378911-69dfcac44df61c1a2db2bd72e6dd0f27.jpg', NULL, 1, '2026-09-26 06:32:58'),
(9, 4, -7.4107083, 112.6273617, 35.74, NULL, 'Gagal Verifikasi Wajah', 'attendance/1790404458941-bca4e17b06b105592446779455ff5066.jpg', NULL, 1, '2026-09-26 06:34:18'),
(10, 4, -7.410185, 112.6272433, 23.92, 80.47, 'Clock In', 'attendance/1790405667704-0f16b8f2c125d33ce90b36b239bc579a.jpg', NULL, 1, '2026-09-26 06:54:28'),
(15, 7, -7.4106473, 112.6273149, 28.12, 77.59, 'Clock In', 'attendance/1790406571918-2e98442a8c767933dc858a21bdb15e39.jpg', NULL, 1, '2026-09-26 07:09:33'),
(16, 7, -7.410645, 112.6273155, 27.87, 30.31, 'Wajah Tidak Cocok', 'attendance/1790406580670-7adc0be87b98a77ce1955b4ce5cbbb3c.jpg', NULL, 1, '2026-09-26 07:09:41'),
(24, 4, -7.324999, 112.7216821, 11.31, 75.04, 'Clock In', 'attendance/1790562195549-a3ada951cee7655bb19c7e299b279815.jpg', NULL, 1, '2026-09-28 02:23:16'),
(25, 4, -7.3249961, 112.7216841, 11.68, 75.11, 'Clock Out', 'attendance/1790562504376-bea469858124cf0455eb4ad3dd5063cc.jpg', NULL, 1, '2026-09-28 02:28:25'),
(26, 4, 0, 0, 0, NULL, 'Izin', NULL, NULL, NULL, '2026-09-28 02:40:08'),
(27, 8, -7.322961, 112.7213576, 234.92, NULL, 'Di Luar Radius', 'attendance/1790567655287-ea2fd10f3a44a252cc8781f7ab110fa1.jpg', NULL, 1, '2026-09-28 03:54:15'),
(28, 8, -7.322961, 112.7213576, 234.92, NULL, 'Di Luar Radius', 'attendance/1790567675629-bf59fe4bc721f85d2108a67460de781d.jpg', NULL, 1, '2026-09-28 03:54:36'),
(29, 8, -7.3242813, 112.721642, 87.45, NULL, 'Di Luar Radius', 'attendance/1790567809387-8b590e26c3413ccf8fe717b13f415ef7.jpg', NULL, 1, '2026-09-28 03:56:50'),
(30, 8, -7.3283341, 112.7209852, 371.36, NULL, 'Di Luar Radius', 'attendance/1790567831209-57153f5421885bd5f2c0409908e9e3f6.jpg', NULL, 1, '2026-09-28 03:57:11'),
(31, 8, -7.3250217, 112.7218983, 24.34, 74.34, 'Clock In', 'attendance/1790567841699-7f977592c47516181dbeffc2bbea1058.jpg', NULL, 1, '2026-09-28 03:57:23'),
(32, 8, -7.3249865, 112.7218629, 21.82, 31.42, 'Wajah Tidak Cocok', 'attendance/1790567855252-01691dd3818c7c01cc3ca96f307aee88.jpg', NULL, 1, '2026-09-28 03:57:36'),
(33, 8, -7.325083, 112.7216289, 6.17, 100, 'Clock Out', 'attendance/1790576739002-b56c24ec73b05feb35678875a9cf72e4.jpg', NULL, 1, '2026-09-28 06:25:39'),
(34, 3, -7.324955, 112.7217167, 12.99, 100, 'Clock In', 'attendance/1790586404740-d5a157796587bae5c3ff73a02e88f423.jpg', NULL, 1, '2026-09-28 09:06:45'),
(35, 4, -7.3249927, 112.7216784, 8.24, 100, 'Clock In', 'attendance/1790647636721-b08deae6101c96fea4a8bd616b62c38f.jpg', NULL, 1, '2026-09-29 02:07:16'),
(36, 4, -7.3249927, 112.7216784, 8.24, NULL, 'Clock Out', NULL, NULL, 1, '2026-09-29 02:07:21'),
(37, 3, -7.3249225, 112.7216121, 17.81, 100, 'Clock In', 'attendance/1790647722551-97c0da67f890197b7ce6f7b7484d2387.jpg', NULL, 1, '2026-09-29 02:08:42'),
(38, 3, -7.3249883, 112.7216599, 9.07, NULL, 'Clock Out', NULL, NULL, 1, '2026-09-29 02:08:58'),
(39, 8, -7.3249936, 112.7216778, 8.15, 100, 'Clock In', 'attendance/1790648038474-e2af67fbaf075e6970848096d91f801b.jpg', NULL, 1, '2026-09-29 02:13:58'),
(40, 7, -7.3249978, 112.7216715, 7.76, 100, 'Clock In', 'attendance/1790648073461-510bd13bff42ad189ca9f424e9a21697.jpg', NULL, 1, '2026-09-29 02:14:33');

-- --------------------------------------------------------

--
-- Table structure for table `leave_requests`
--

CREATE TABLE `leave_requests` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `reason` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `attachment` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('pending','approved','rejected') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `reviewed_by` int DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `leave_requests`
--

INSERT INTO `leave_requests` (`id`, `user_id`, `reason`, `description`, `attachment`, `status`, `reviewed_by`, `reviewed_at`, `created_at`, `updated_at`) VALUES
(2, 4, 'ahshha', 'ajsnsn', 'uploads/leaves/leave_1790563202045-983260788.jpg', 'approved', 2, '2026-09-28 09:40:08', '2026-09-28 09:40:02', '2026-09-28 09:40:08'),
(3, 3, 'sakit', 'sakit perut', 'uploads/leaves/leave_1790588066836-903324487.jpg', 'pending', NULL, NULL, '2026-09-28 16:34:27', '2026-09-28 16:34:27'),
(4, 3, 'sakit', 'sakit kepala', 'uploads/leaves/leave_1790588277267-958615179.jpg', 'pending', NULL, NULL, '2026-09-28 16:37:57', '2026-09-28 16:37:57');

-- --------------------------------------------------------

--
-- Table structure for table `locations`
--

CREATE TABLE `locations` (
  `id` int NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nama lokasi (misal: Kantor Pusat, Kampus A)',
  `latitude` double NOT NULL,
  `longitude` double NOT NULL,
  `radius` int DEFAULT '100' COMMENT 'Radius geofencing dalam meter',
  `is_active` tinyint(1) DEFAULT '1' COMMENT '1 = aktif, 0 = nonaktif',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `locations`
--

INSERT INTO `locations` (`id`, `name`, `latitude`, `longitude`, `radius`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Kantor Pusat', -7.325066726186988, 112.72168235271651, 50, 1, '2026-09-24 04:56:31', '2026-09-28 03:55:52');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nip` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nomor Induk Pegawai/Mahasiswa',
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('admin','user') COLLATE utf8mb4_unicode_ci DEFAULT 'user',
  `face_photo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Path relatif ke foto master wajah',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `nip`, `password`, `role`, `face_photo`, `created_at`, `updated_at`) VALUES
(1, 'Administrator', 'admin@absensi.com', 'ADMIN001', '$2a$12$DxxwPtsPrLc85XHBxQiFWeBdq2b538RJM/Zp3KNy63ILV62SxSq9m', 'admin', NULL, '2026-09-24 04:56:31', '2026-09-24 08:09:21'),
(2, 'Nama Admin Baru', 'adminbaru@absensi.com', 'ADMIN002', '$2a$12$HKKq5VTESkW7/mcaTs7TMO5uoTX5l30cMiSQ2yjgqGCEf5/YcPhZW', 'admin', NULL, '2026-09-24 08:21:18', '2026-09-24 08:25:23'),
(3, 'catur', 'catur@gmail.com', '13213123', '$2a$12$jLSSBxbnGGFgXCfnFLUMJuRUfmNVD1iEZvMlXl5oVf.MUMOdTiofq', 'user', 'faces/1790304755407-3d74dc6cf17b609ea0cc466b397c33a7.jpg', '2026-09-25 02:52:36', '2026-09-25 02:52:36'),
(4, 'royhan', 'royhan', '1234567', '$2a$12$u9dzYYv0a8/c9l46kvmAIuMMavi2/MRsqkKpLyPUR6FknsVPFI2mm', 'user', 'faces/1790323825709-14ac2810dfc4fb49e3534dbd6c133392.jpg', '2026-09-25 08:10:26', '2026-09-25 08:10:26'),
(7, 'alin', 'alin', '123', '$2a$12$9X5bFXL5dER2ODQfhh2NUe/Smsyeke1MBUk4KufBm8RZ9gdx/grhi', 'user', 'faces/1790406548000-276fb68e721da5db68a71e46c504908e.jpg', '2026-09-26 07:09:08', '2026-09-26 07:09:08'),
(8, 'aa', 'aa', '1234', '$2a$12$mTAyBZntbwmeM7opSyFuluxnRTZtT8tO1jssPOh.tacu2sZEen.n6', 'user', 'faces/1790567613893-d98d087099dd9b9a39615abc0abaf402.jpg', '2026-09-28 03:53:34', '2026-09-28 03:53:34');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `attendance_logs`
--
ALTER TABLE `attendance_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `location_id` (`location_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_user_date` (`user_id`,`created_at`);

--
-- Indexes for table `leave_requests`
--
ALTER TABLE `leave_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `reviewed_by` (`reviewed_by`);

--
-- Indexes for table `locations`
--
ALTER TABLE `locations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_active` (`is_active`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `nip` (`nip`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_nip` (`nip`),
  ADD KEY `idx_role` (`role`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `attendance_logs`
--
ALTER TABLE `attendance_logs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `leave_requests`
--
ALTER TABLE `leave_requests`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `locations`
--
ALTER TABLE `locations`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `attendance_logs`
--
ALTER TABLE `attendance_logs`
  ADD CONSTRAINT `attendance_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `attendance_logs_ibfk_2` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `leave_requests`
--
ALTER TABLE `leave_requests`
  ADD CONSTRAINT `leave_requests_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `leave_requests_ibfk_2` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;
--
-- Database: `database_pemrograman_framework`
--
CREATE DATABASE IF NOT EXISTS `database_pemrograman_framework` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `database_pemrograman_framework`;

-- --------------------------------------------------------

--
-- Table structure for table `kategori`
--

CREATE TABLE `kategori` (
  `id_kategori` int NOT NULL,
  `nama_kategori` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `kategori`
--

INSERT INTO `kategori` (`id_kategori`, `nama_kategori`) VALUES
(2, 'jam tangan'),
(4, 'Elektronik'),
(5, 'sepatu'),
(6, 'baju'),
(8, 'jaket'),
(9, 'celana');

-- --------------------------------------------------------

--
-- Table structure for table `produk`
--

CREATE TABLE `produk` (
  `id` int NOT NULL,
  `nama_produk` varchar(255) DEFAULT NULL,
  `gambar_produk` varchar(255) DEFAULT NULL,
  `kategori_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `produk`
--

INSERT INTO `produk` (`id`, `nama_produk`, `gambar_produk`, `kategori_id`) VALUES
(1, 'Kemeja Flanel', '1776140955916.png', 8),
(2, 'Celana Chino', '1776141005451.png', 9),
(3, 'Jaket Denim', '1776141018840.png', 8),
(4, 'Kaos Polos', '1776147204967.png', 6);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `created_at`) VALUES
(1, 'admin', 'password_terenkripsi_123', '2026-04-07 05:11:04'),
(2, 'royhan123', '$2b$10$CHhcqDMgmxS1jb8FobAHHuc1JFg/4CdZmJx7gK9O2fEA2av4T8uHy', '2026-04-07 06:15:50'),
(3, 'roy', '$2b$10$3lRAeZoYr4w6XR1KFzMGrOTRUGjvFElrf77g2p2gGBmhNQUJzoPzC', '2026-04-13 15:23:13'),
(4, '123', '$2b$10$jcbCZhTHIgBYqRZ287hlIuXgClR8ELGj3u8h9cAesfQ/nXhXKyjxi', '2026-04-14 04:58:12');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`id_kategori`);

--
-- Indexes for table `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `kategori`
--
ALTER TABLE `kategori`
  MODIFY `id_kategori` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `produk`
--
ALTER TABLE `produk`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- Database: `db_deteksi_penyakit_tanaman`
--
CREATE DATABASE IF NOT EXISTS `db_deteksi_penyakit_tanaman` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `db_deteksi_penyakit_tanaman`;

-- --------------------------------------------------------

--
-- Table structure for table `hasil_deteksi`
--

CREATE TABLE `hasil_deteksi` (
  `id_deteksi` int NOT NULL,
  `id_pengguna` int DEFAULT NULL,
  `id_penyakit` int NOT NULL,
  `gambar_upload` varchar(255) NOT NULL,
  `gambar_gradcam` longtext,
  `tingkat_keyakinan` float NOT NULL,
  `tanggal_deteksi` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `hasil_deteksi`
--

INSERT INTO `hasil_deteksi` (`id_deteksi`, `id_pengguna`, `id_penyakit`, `gambar_upload`, `gambar_gradcam`, `tingkat_keyakinan`, `tanggal_deteksi`) VALUES
(2, 1, 4, '1777981741621-scaled_1000397748.jpg', NULL, 0.9995, '2026-05-05 11:49:01'),
(4, 1, 2, '1777981764437-scaled_1000398266.png', NULL, 0.9822, '2026-05-05 11:49:24'),
(5, 1, 1, '1777981775400-scaled_1000398265.jpg', NULL, 0.7328, '2026-05-05 11:49:35'),
(6, 1, 1, '1777981897838-b0f6ff75-57b0-4e99-9403-3cee48995e11___FAM_B.Rot_3365.JPG', NULL, 1, '2026-05-05 11:51:37'),
(7, 1, 1, '1777981907698-b7da3499-648a-482b-8f9c-be7bb48bb53b___FAM_B.Rot_0561.JPG', NULL, 0.9989, '2026-05-05 11:51:47'),
(8, 1, 3, '1777981919372-a42b48cb-f43b-4ad4-ace4-e7e20f1ecd03___FAM_L.Blight_4786.JPG', NULL, 1, '2026-05-05 11:51:59'),
(10, 1, 4, '1777983471106-scaled_1000397748.jpg', NULL, 0.9862, '2026-05-05 12:17:53'),
(11, 1, 3, '1777983523998-a3c0ea9e-826f-4898-a614-e2ab42ecd1bc___FAM_L.Blight_4701.JPG', NULL, 1, '2026-05-05 12:18:44'),
(18, 2, 1, '1777992159360-cropped_leaf.jpg', NULL, 0.9999, '2026-05-05 14:42:39'),
(19, 2, 1, '1777992185175-cropped_leaf.jpg', NULL, 0.9865, '2026-05-05 14:43:05'),
(20, 2, 1, '1777993244395-cropped_leaf.jpg', NULL, 1, '2026-05-05 15:00:44'),
(21, 2, 2, '1777993258640-cropped_leaf.jpg', NULL, 1, '2026-05-05 15:00:58'),
(22, 2, 4, '1777993273731-cropped_leaf.jpg', NULL, 1, '2026-05-05 15:01:13'),
(23, 2, 3, '1777993288675-cropped_leaf.jpg', NULL, 1, '2026-05-05 15:01:28'),
(24, 2, 1, '1777993872735-cropped_leaf.jpg', NULL, 1, '2026-05-05 15:11:12'),
(25, 2, 1, '1777994387612-cropped_leaf.jpg', NULL, 1, '2026-05-05 15:19:47'),
(26, 2, 1, '1777994563352-cropped_leaf.jpg', NULL, 1, '2026-05-05 15:22:43'),
(27, 2, 3, '1777995447884-scaled_b7693215-f8d0-442d-93ed-095a8e09d3368666611492470078404.jpg', NULL, 0.9249, '2026-05-05 15:37:28'),
(28, 2, 3, '1777995836698-scaled_ef3c4a2b-e664-4711-937c-969b1a89efe61739873951819020431.jpg', NULL, 0.9999, '2026-05-05 15:44:01'),
(29, 2, 3, '1777995858475-scaled_2303e91a-d68a-4b1e-b2c8-de2784facb2c5322207348384869346.jpg', NULL, 0.9997, '2026-05-05 15:44:18'),
(30, 2, 1, '1777995886704-cropped_leaf.jpg', NULL, 1, '2026-05-05 15:44:46'),
(31, 2, 1, '1777996581092-cropped_leaf.jpg', NULL, 0.9994, '2026-05-05 15:56:21'),
(32, 2, 1, '1777997732627-cropped_leaf.jpg', NULL, 1, '2026-05-05 16:15:36'),
(33, 2, 4, '1777997830753-cropped_leaf.jpg', NULL, 1, '2026-05-05 16:17:10'),
(34, 2, 4, '1777998476974-cropped_leaf.jpg', NULL, 1, '2026-05-05 16:27:57'),
(35, 2, 2, '1777998495749-cropped_leaf.jpg', NULL, 1, '2026-05-05 16:28:15'),
(36, 2, 2, '1777998614234-cropped_leaf.jpg', NULL, 1, '2026-05-05 16:30:14'),
(37, 2, 4, '1777998628336-cropped_leaf.jpg', NULL, 1, '2026-05-05 16:30:28'),
(38, 2, 4, '1777999163504-scaled_1000155434.jpg', NULL, 1, '2026-05-05 16:39:23'),
(39, 2, 4, '1777999197969-scaled_1000155434.jpg', NULL, 1, '2026-05-05 16:39:58'),
(40, 2, 3, '1777999205666-scaled_1000155437.jpg', NULL, 1, '2026-05-05 16:40:05'),
(41, 2, 1, '1781195203019-cropped_leaf.jpg', NULL, 1, '2026-06-11 16:26:47'),
(42, 2, 2, '1781195256634-cropped_leaf.jpg', NULL, 1, '2026-06-11 16:27:36'),
(43, 2, 4, '1781195295586-cropped_leaf.jpg', NULL, 1, '2026-06-11 16:28:15'),
(44, 2, 3, '1781195313247-cropped_leaf.jpg', NULL, 1, '2026-06-11 16:28:33'),
(45, 2, 4, '1781195494198-cropped_leaf.jpg', NULL, 1, '2026-06-11 16:31:34'),
(46, 2, 3, '1781195505736-cropped_leaf.jpg', NULL, 1, '2026-06-11 16:31:45'),
(47, 2, 2, '1781195518332-cropped_leaf.jpg', NULL, 1, '2026-06-11 16:31:58'),
(48, 2, 1, '1781195531703-cropped_leaf.jpg', NULL, 0.9818, '2026-06-11 16:32:11'),
(49, 2, 4, '1781233155784-cropped_leaf.jpg', NULL, 1, '2026-06-12 02:59:16'),
(50, 2, 3, '1781233263024-cropped_leaf.jpg', NULL, 1, '2026-06-12 03:01:03'),
(51, 2, 1, '1781233983431-cropped_leaf.jpg', NULL, 0.9818, '2026-06-12 03:13:03'),
(52, 2, 2, '1781235281678-cropped_leaf.jpg', NULL, 1, '2026-06-12 03:34:41');

-- --------------------------------------------------------

--
-- Table structure for table `penanganan`
--

CREATE TABLE `penanganan` (
  `id_penanganan` int NOT NULL,
  `id_penyakit` int NOT NULL,
  `judul_penanganan` varchar(255) NOT NULL,
  `deskripsi_penanganan` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `penanganan`
--

INSERT INTO `penanganan` (`id_penanganan`, `id_penyakit`, `judul_penanganan`, `deskripsi_penanganan`) VALUES
(1, 1, 'Sanitasi Kebun & Pemusnahan Sumber Inokulum', 'Langkah pertama dan paling krusial dalam pengendalian Black Rot adalah melakukan sanitasi kebun secara menyeluruh dan konsisten. Kumpulkan dan musnahkan semua mumi buah (buah yang mengering dan menghitam) baik yang masih menempel di pohon maupun yang sudah jatuh ke tanah, karena mumi buah merupakan sumber utama spora jamur Guignardia bidwellii untuk infeksi di musim berikutnya. Potong dan bakar seluruh daun, ranting, dan sulur yang menunjukkan gejala infeksi berupa bercak cokelat nekrotik. Lakukan pembersihan ini secara rutin setiap minggu selama musim tanam aktif dan secara menyeluruh setelah panen selesai. Pastikan tidak ada sisa-sisa tanaman terinfeksi yang tertinggal di dalam kebun karena satu mumi buah saja sudah cukup untuk melepaskan ribuan spora yang mampu menginfeksi tanaman baru di musim depan. Gunakan mulsa plastik atau jerami bersih untuk menutup permukaan tanah di bawah kanopi guna mencegah percikan air hujan membawa spora dari tanah ke daun.'),
(2, 1, 'Aplikasi Fungisida Preventif Secara Terjadwal', 'Terapkan program penyemprotan fungisida preventif secara terjadwal dimulai sejak tunas baru mulai tumbuh (3-5 cm) dan dilanjutkan setiap 7-14 hari hingga buah memasuki fase veraison (perubahan warna). Gunakan fungisida berbahan aktif Mancozeb atau Captan sebagai perlindungan kontak pada tahap awal musim tanam, kemudian ganti ke fungisida sistemik seperti Myclobutanil, Thiophanate-methyl, atau Tebuconazole saat buah mulai terbentuk untuk perlindungan yang lebih mendalam ke dalam jaringan tanaman. Selalu rotasikan penggunaan fungisida dengan mode aksi yang berbeda (FRAC group berbeda) setiap 2-3 kali penyemprotan untuk mencegah resistensi jamur. Lakukan penyemprotan pada pagi hari saat angin tenang dan hindari penyemprotan saat hujan deras. Pastikan nozzle sprayer menghasilkan butiran halus yang merata menutupi seluruh permukaan daun, batang, dan buah. Catat setiap aplikasi (tanggal, jenis fungisida, konsentrasi) untuk evaluasi efektivitas di akhir musim.'),
(3, 1, 'Pengelolaan Kanopi & Perbaikan Drainase Kebun', 'Lakukan pemangkasan kanopi secara strategis untuk meningkatkan sirkulasi udara dan penetrasi sinar matahari ke seluruh bagian tanaman, karena kondisi lembap dan teduh sangat mendukung perkembangan jamur Black Rot. Pangkas cabang-cabang yang tumbuh terlalu rapat, buang tunas air (water sprout) yang tidak produktif, dan atur posisi sulur-sulur agar tidak saling bertumpukan. Idealnya, jarak antar cabang utama minimal 15-20 cm untuk memastikan aliran udara yang optimal. Perbaiki sistem drainase kebun dengan membuat parit-parit pembuangan air yang memadai, terutama pada lahan yang cenderung tergenang saat musim hujan. Pertimbangkan untuk menaikkan bedengan tanam 20-30 cm di atas permukaan tanah asli pada kebun baru. Atur jarak tanam yang cukup antar pohon (minimal 2-3 meter antar baris) dan pastikan orientasi baris tanaman searah dengan arah angin dominan untuk memaksimalkan pengeringan alami permukaan daun setelah hujan. Kurangi pemupukan nitrogen berlebihan yang mendorong pertumbuhan vegetatif rimbun dan rentan penyakit.'),
(4, 2, 'Pemangkasan Sanitasi & Perlindungan Luka Potong', 'Langkah paling penting dalam pengelolaan Black Measles adalah melakukan pemangkasan sanitasi yang tepat dan melindungi setiap luka potongan dari infeksi jamur. Lakukan pemangkasan hanya pada kondisi cuaca kering dan cerah, hindari memangkas saat hujan atau udara sangat lembap karena spora jamur Phaeomoniella dan Phaeoacremonium sangat aktif dalam kondisi basah. Sterilisasi alat pemangkas (gunting, gergaji) dengan larutan alkohol 70% atau sodium hipoklorit 2% sebelum berpindah dari satu pohon ke pohon lainnya untuk mencegah penularan silang. Segera setelah memotong cabang, oleskan pasta penutup luka (wound sealant) atau cat pelindung berbahan dasar akrilik yang dicampur fungisida (seperti Thiophanate-methyl) pada seluruh permukaan luka potong. Biarkan pasta mengering sempurna sebelum terkena air. Cabut dan bakar semua cabang dan batang yang menunjukkan gejala diskolorasi internal (warna cokelat kehitaman pada kayu saat dipotong melintang). Untuk tanaman yang sudah terinfeksi parah, lakukan pemangkasan retrotraitement yaitu memotong batang jauh di bawah area yang terinfeksi hingga tampak jaringan kayu yang bersih berwarna putih kekuningan.'),
(5, 2, 'Aplikasi Fungisida & Agen Hayati pada Jaringan Kayu', 'Terapkan kombinasi fungisida dan agen pengendali hayati untuk melindungi tanaman dari infeksi jamur penyebab Black Measles. Injeksikan larutan fungisida sistemik berbahan aktif Fosetil-Aluminium atau Propiconazole langsung ke dalam batang utama menggunakan metode trunk injection pada awal musim tanam untuk memberikan perlindungan internal. Semprotkan fungisida kontak berbasis tembaga (Copper Hydroxide atau Bordeaux mixture) pada seluruh permukaan batang dan cabang setelah pemangkasan musiman, fokuskan terutama pada area luka-luka potongan dan persimpangan cabang yang rentan terhadap infeksi. Kombinasikan dengan penggunaan agen hayati Trichoderma harzianum yang diaplikasikan sebagai pasta pada luka potong atau sebagai larutan yang disiramkan ke zona perakaran. Trichoderma berfungsi sebagai kolonisator kompetitif yang menghalangi pertumbuhan jamur patogen pada jaringan luka. Ulangi aplikasi agen hayati setiap 3-4 bulan terutama menjelang dan selama musim hujan. Lakukan monitoring rutin dengan memotong sampel cabang kecil secara acak dan memeriksa apakah ada diskolorasi internal sebagai tanda awal infeksi.'),
(6, 2, 'Pengelolaan Stres Tanaman & Revitalisasi Kebun', 'Tanaman anggur yang mengalami stres berkepanjangan jauh lebih rentan terhadap perkembangan gejala Black Measles, terutama apoplexy (kematian mendadak). Kelola stres tanaman dengan menerapkan program irigasi yang konsisten dan teratur, hindari fluktuasi ekstrem antara kekeringan dan kelebihan air yang dapat memicu manifestasi gejala secara tiba-tiba. Berikan pemupukan seimbang dengan mengurangi dosis nitrogen dan meningkatkan asupan kalium dan kalsium yang berperan memperkuat dinding sel dan meningkatkan ketahanan alami tanaman terhadap infeksi jamur. Aplikasikan kompos matang atau bahan organik berkualitas tinggi sebanyak 5-10 kg per pohon per tahun untuk memperbaiki struktur tanah dan meningkatkan populasi mikroorganisme tanah yang menguntungkan. Pertimbangkan program peremajaan kebun (replanting) secara bertahap untuk pohon-pohon yang sudah berusia sangat tua (>20 tahun) dan menunjukkan gejala Esca kronis yang parah, karena tanaman tua dengan banyak luka pemangkasan historis sangat sulit dipulihkan. Pada kebun baru, gunakan bibit bersertifikat bebas penyakit dari nursery terpercaya dan hindari penggunaan batang bawah dari tanaman induk yang terinfeksi.'),
(7, 3, 'Sanitasi Daun Terinfeksi & Pengelolaan Kanopi', 'Langkah utama dalam mengendalikan Isariopsis Leaf Spot adalah menghilangkan sumber inokulum (spora jamur) melalui sanitasi menyeluruh dan mengelola lingkungan mikro kanopi tanaman. Segera singkirkan semua daun yang menunjukkan gejala bercak kuning-cokelat dengan halo kuning, terutama daun-daun tua di bagian bawah kanopi yang biasanya terserang lebih dulu. Kumpulkan juga daun-daun yang sudah gugur di permukaan tanah karena spora jamur Pseudocercospora vitis dapat tetap hidup dan menjadi sumber infeksi baru. Musnahkan semua daun terinfeksi dengan cara dibakar atau dimasukkan ke dalam kantong plastik tertutup dan dibuang jauh dari area kebun, jangan dikomposkan karena spora kemungkinan masih dapat bertahan. Lakukan pemangkasan kanopi secara rutin setiap 2-3 minggu untuk membuka ruang sirkulasi udara di dalam tajuk tanaman, pangkas tunas-tunas lateral yang tumbuh terlalu rapat dan arahkan pertumbuhan cabang utama pada sistem teralis agar terpapar sinar matahari secara optimal. Kondisi kanopi yang terbuka dan kering akan secara signifikan mengurangi kelembapan mikro yang dibutuhkan jamur untuk berkecambah dan menginfeksi jaringan daun baru.'),
(8, 3, 'Program Penyemprotan Fungisida Terpadu', 'Implementasikan program penyemprotan fungisida secara preventif dan kuratif untuk mengendalikan perkembangan Isariopsis Leaf Spot sepanjang musim tanam. Mulai penyemprotan preventif menggunakan fungisida kontak berbasis sulfur (Wettable Sulphur) atau tembaga (Copper Oxychloride) dengan konsentrasi sesuai anjuran label pada saat daun-daun baru mulai berkembang penuh, ulangi setiap 10-14 hari terutama selama periode hujan. Untuk penyemprotan kuratif saat gejala sudah muncul, gunakan fungisida sistemik seperti Azoxystrobin, Difenoconazole, atau Carbendazim yang mampu menembus ke dalam jaringan daun dan menghentikan pertumbuhan miselium jamur. Rotasikan minimal 3 jenis fungisida dengan mode aksi berbeda sepanjang satu musim tanam untuk menghindari terjadinya resistensi jamur terhadap bahan aktif tertentu. Lakukan penyemprotan pada pagi hari (jam 06.00-09.00) atau sore hari (jam 16.00-18.00) saat suhu tidak terlalu panas dan tidak ada angin kencang agar larutan menempel sempurna pada permukaan daun. Tambahkan bahan perekat (sticker/spreader) ke dalam campuran semprot untuk meningkatkan daya rekat dan pemerataan larutan fungisida, terutama pada permukaan bawah daun dimana spora jamur paling banyak berkembang.'),
(9, 3, 'Optimalisasi Nutrisi & Ketahanan Alami Tanaman', 'Perkuat ketahanan alami tanaman anggur terhadap serangan Isariopsis Leaf Spot melalui program nutrisi yang optimal dan seimbang. Berikan pupuk yang mengandung kalium (K) dan kalsium (Ca) dalam jumlah cukup karena kedua unsur ini berperan vital dalam memperkuat dinding sel daun sehingga lebih tahan terhadap penetrasi hifa jamur. Aplikasikan pupuk kalium sulfat (K2SO4) dengan dosis 200-300 gram per pohon per aplikasi sebanyak 2-3 kali selama musim tanam. Hindari pemupukan nitrogen berlebihan karena pertumbuhan daun yang terlalu sukulen (lunak dan berair) justru lebih mudah terinfeksi oleh spora jamur. Tambahkan mikronutrien seperti Mangan (Mn) dan Seng (Zn) melalui penyemprotan daun (foliar spray) karena kedua unsur ini berperan sebagai ko-faktor enzim pertahanan tanaman. Pertimbangkan penggunaan biostimulan berbasis ekstrak rumput laut (Ascophyllum nodosum) atau asam humat yang telah terbukti meningkatkan produksi fitoaleksin dan enzim pertahanan alami tanaman. Jaga kelembapan tanah tetap konsisten melalui irigasi tetes (drip irrigation) dan hindari penyiraman dari atas (overhead sprinkler) yang menyebarkan spora jamur dan menciptakan kondisi basah pada permukaan daun yang menguntungkan perkembangan penyakit.'),
(10, 4, 'Program Perawatan Rutin & Monitoring Kesehatan', 'Pertahankan kondisi sehat tanaman anggur dengan menerapkan program perawatan rutin yang komprehensif dan terjadwal. Lakukan inspeksi visual menyeluruh pada seluruh tanaman minimal sekali seminggu, periksa permukaan atas dan bawah daun, batang, sulur, dan buah untuk mendeteksi tanda-tanda awal infeksi penyakit, serangan hama, atau defisiensi nutrisi sebelum menjadi masalah serius. Dokumentasikan setiap temuan menggunakan fitur scan pada aplikasi rassyhvre untuk membangun catatan kesehatan tanaman yang sistematis dari waktu ke waktu. Terapkan jadwal penyiraman yang konsisten, idealnya menggunakan sistem irigasi tetes (drip irrigation) yang memberikan air langsung ke zona perakaran dengan volume 10-15 liter per pohon per hari pada musim panas dan 5-8 liter pada musim sejuk. Lakukan pemangkasan pembentukan (training pruning) secara teratur untuk menjaga arsitektur tanaman yang efisien, memastikan setiap cabang mendapatkan paparan sinar matahari yang memadai, dan mencegah pertumbuhan kanopi yang terlalu rapat. Bersihkan gulma di sekitar pangkal batang secara rutin dalam radius minimal 50 cm untuk mengurangi kompetisi nutrisi dan kelembapan berlebihan yang dapat memicu penyakit akar.'),
(11, 4, 'Pemupukan Seimbang & Pengelolaan Kesuburan Tanah', 'Jaga kesuburan tanah dan nutrisi tanaman dengan program pemupukan yang terencana berdasarkan hasil analisis tanah dan kebutuhan tanaman di setiap fase pertumbuhan. Lakukan uji tanah setiap 6 bulan untuk mengetahui status pH, kandungan unsur makro (N, P, K) dan mikro (Fe, Mn, Zn, B, Cu), serta kadar bahan organik tanah. Targetkan pH tanah optimal antara 5.5-7.0 dengan mengaplikasikan kapur dolomit jika terlalu asam atau sulfur jika terlalu basa. Terapkan jadwal pemupukan bertahap: berikan pupuk nitrogen tinggi (Urea atau ZA) pada awal musim tanam saat tunas mulai tumbuh, ganti ke pupuk berimbang NPK (15-15-15) saat fase pembungaan, dan tingkatkan porsi kalium (KCl atau K2SO4) saat buah mulai terbentuk dan memasuki fase pematangan. Tambahkan pupuk organik berkualitas berupa kompos matang atau pupuk kandang fermentasi sebanyak 10-15 kg per pohon per tahun yang diberikan pada awal musim tanam untuk memperbaiki struktur tanah, meningkatkan kapasitas menahan air, dan menyediakan nutrisi lepas lambat. Aplikasikan mikoriza pada saat penanaman atau setiap tahun untuk meningkatkan efisiensi penyerapan fosfor dan unsur hara lainnya oleh akar.'),
(12, 4, 'Pencegahan Penyakit & Pengendalian Hama Terpadu', 'Meskipun tanaman dalam kondisi sehat, program pencegahan penyakit dan pengendalian hama terpadu (Integrated Pest Management/IPM) harus tetap dijalankan secara konsisten untuk mempertahankan status kesehatan dan mencegah infeksi di masa mendatang. Terapkan penyemprotan fungisida preventif berbasis tembaga atau sulfur secara berkala setiap 14-21 hari selama musim hujan sebagai tindakan pencegahan terhadap jamur patogen. Gunakan perangkap serangga (sticky trap berwarna kuning) yang dipasang setiap 10-15 meter di sepanjang baris tanaman untuk memantau populasi hama seperti kutu kebul, thrips, dan lalat buah. Terapkan pengendalian hayati dengan melepas predator alami seperti Trichogramma untuk pengendalian ulat penggerek buah dan Phytoseiulus persimilis untuk pengendalian tungau laba-laba. Jaga kebersihan kebun dengan rutin membersihkan daun-daun yang gugur, membuang buah busuk, dan memangkas cabang mati yang bisa menjadi tempat berlindung hama dan patogen. Pasang penghalang fisik berupa jaring anti-serangga (insect net) di sekeliling kebun jika tekanan hama tinggi. Catat semua aplikasi pestisida, hasil monitoring, dan kondisi cuaca dalam buku log kebun untuk membangun basis data pengelolaan kebun yang efektif dan berkelanjutan.');

-- --------------------------------------------------------

--
-- Table structure for table `pengguna`
--

CREATE TABLE `pengguna` (
  `id_pengguna` int NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(50) DEFAULT 'user',
  `foto_profil` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pengguna`
--

INSERT INTO `pengguna` (`id_pengguna`, `nama`, `email`, `password`, `role`, `foto_profil`) VALUES
(1, 'Zakyyah Nur Azizah', 'azizah@gmail.com', '$2b$10$Zu4Byz9.TJFvGrDpM7CO7OCPw2l/Mu14ogIe7Qvh7L1MAhYBwXQG.', 'user', '1777982001793-image_cropper_1777981998617.jpg'),
(2, 'alinda', 'alinda@gmail.com', '$2b$10$7B3jkIA1CmHFKJMwUFcOre3eQKvjHFzYLQuAJ1uu38Sdj.stFAjPq', 'user', '1777993750182-WhatsApp_Image_2026-01-16_at_10.33.19.jpeg');

-- --------------------------------------------------------

--
-- Table structure for table `penyakit`
--

CREATE TABLE `penyakit` (
  `id_penyakit` int NOT NULL,
  `nama_penyakit` varchar(100) NOT NULL,
  `deskripsi` text,
  `penyebab` text,
  `gambar_contoh` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `penyakit`
--

INSERT INTO `penyakit` (`id_penyakit`, `nama_penyakit`, `deskripsi`, `penyebab`, `gambar_contoh`) VALUES
(1, 'Black Rot', 'Black Rot (Guignardia bidwellii) adalah salah satu penyakit paling merusak pada tanaman anggur yang disebabkan oleh jamur Guignardia bidwellii. Penyakit ini menyerang seluruh bagian tanaman termasuk daun, batang, sulur, dan buah. Gejala awal muncul berupa bercak-bercak kecil berwarna cokelat kemerahan pada permukaan daun yang secara bertahap membesar dan membentuk lesi nekrotik berwarna cokelat tua dengan tepi gelap yang khas. Pada buah, infeksi menyebabkan pembusukan total dimana buah berubah warna menjadi hitam, mengkerut, dan mengeras menjadi mumi (mumifikasi). Jamur ini bertahan hidup pada sisa-sisa tanaman yang terinfeksi selama musim dingin dan menyebar melalui percikan air hujan pada musim semi. Kondisi lingkungan yang hangat (21-27°C) dan lembap sangat mendukung perkembangan penyakit ini. Kerugian ekonomi akibat Black Rot bisa mencapai 80% dari total panen jika tidak ditangani dengan baik.', 'Penyakit Black Rot disebabkan oleh jamur patogen Guignardia bidwellii (anamorph: Phyllosticta ampelicida). Jamur ini bertahan hidup pada mumi buah, daun yang gugur, dan jaringan tanaman yang terinfeksi dari musim sebelumnya. Spora (askospora) dilepaskan saat kondisi basah dan hangat pada awal musim tanam, kemudian tersebar melalui percikan air hujan dan angin ke jaringan tanaman yang sehat. Faktor lingkungan yang memperparah meliputi curah hujan tinggi yang berkepanjangan, kelembapan udara di atas 90%, suhu antara 21-27°C, drainase tanah yang buruk, serta kanopi tanaman yang terlalu rapat sehingga menghambat sirkulasi udara. Tanaman anggur yang stres akibat kekurangan nutrisi atau serangan hama juga lebih rentan terhadap infeksi jamur ini.', NULL),
(2, 'Black Measles', 'Black Measles, atau dikenal juga sebagai Esca atau Grapevine Measles, adalah penyakit kompleks dan kronis pada tanaman anggur yang melibatkan beberapa species jamur patogen. Penyakit ini termasuk salah satu penyakit kayu (trunk disease) yang paling sulit dikelola pada kebun anggur di seluruh dunia. Gejala pada daun berupa bercak-bercak klorotik (menguning) antar tulang daun yang kemudian mengering dan berubah menjadi nekrotik berwarna cokelat kemerahan, membentuk pola khas menyerupai gejala campak (measles). Pada buah, muncul bintik-bintik kecil berwarna gelap (dark spots) di permukaan kulit yang mengurangi kualitas dan nilai jual. Pada kasus yang parah, tanaman bisa mengalami apoplexy yaitu kematian mendadak pada cabang atau seluruh pohon akibat penyumbatan pembuluh kayu oleh massa jamur. Penyakit ini berkembang secara perlahan selama bertahun-tahun dan seringkali baru terdeteksi ketika kerusakan internal sudah sangat parah. Black Measles menjadi ancaman serius terutama pada kebun anggur yang sudah berusia tua.', 'Black Measles disebabkan oleh kompleks jamur patogen yang meliputi Phaeomoniella chlamydospora, Phaeoacremonium minimum (sebelumnya P. aleophilum), dan beberapa spesies dari genus Botryosphaeria dan Fomitiporia. Jamur-jamur ini menginfeksi tanaman melalui luka pemangkasan, luka mekanis, atau celah alami pada batang dan cabang. Infeksi awal seringkali terjadi di persemaian atau saat penanaman bibit yang sudah terinfeksi secara laten. Faktor yang memperparah penyakit meliputi pemangkasan yang tidak tepat (terutama saat musim hujan), penggunaan alat pemangkas yang tidak disterilisasi, stres air berkepanjangan, umur tanaman yang sudah tua (>10 tahun), dan praktik budidaya yang buruk. Jamur tumbuh secara perlahan di dalam jaringan kayu batang utama, merusak pembuluh xylem dan phloem sehingga mengganggu distribusi air dan nutrisi ke seluruh bagian tanaman.', NULL),
(3, 'Isariopsis Leaf Spot', 'Isariopsis Leaf Spot, juga dikenal sebagai Leaf Blight atau Pseudocercospora vitis, adalah penyakit daun pada tanaman anggur yang disebabkan oleh jamur Pseudocercospora vitis (sinonim: Isariopsis clavispora). Penyakit ini tersebar luas di daerah tropis dan subtropis dengan iklim hangat dan lembap. Gejala awal berupa bercak-bercak kecil berbentuk tidak beraturan pada permukaan atas daun yang berwarna kuning kehijauan (klorotik), kemudian secara bertahap berubah menjadi cokelat kemerahan hingga cokelat gelap dengan halo kuning di sekelilingnya. Pada permukaan bawah daun, terdapat massa spora jamur berwarna gelap yang tampak seperti beledu atau tepung halus. Infeksi berat menyebabkan daun menguning secara menyeluruh, mengering, dan akhirnya gugur prematur (defoliasi dini). Defoliasi yang parah mengurangi kemampuan fotosintesis tanaman secara drastis, menurunkan kualitas buah, menghambat pematangan, dan melemahkan daya tahan tanaman terhadap stres lingkungan di musim berikutnya. Serangan berulang selama beberapa musim dapat melemahkan pertumbuhan vegetatif tanaman secara signifikan.', 'Penyakit Isariopsis Leaf Spot disebabkan oleh jamur Pseudocercospora vitis (sebelumnya dikenal sebagai Isariopsis clavispora atau Cercospora vitis). Jamur patogen ini menghasilkan konidiospora yang menyebar melalui angin dan percikan air hujan dari daun yang terinfeksi ke daun yang sehat. Spora berkecambah dan menginfeksi jaringan daun melalui stomata (mulut daun) pada permukaan bawah daun. Faktor lingkungan yang sangat mendukung perkembangan penyakit ini meliputi suhu hangat antara 25-30°C, kelembapan relatif tinggi di atas 80%, curah hujan yang sering dan berkepanjangan selama musim tanam, serta kondisi kanopi yang rapat dan kurang ventilasi. Penyakit ini terutama menyerang daun-daun yang sudah tua di bagian bawah kanopi dimana kondisi kelembapan lebih tinggi dan sirkulasi udara lebih buruk.', NULL),
(4, 'Healthy', 'Daun anggur yang sehat (Healthy) menunjukkan kondisi pertumbuhan yang optimal tanpa adanya tanda-tanda infeksi penyakit, serangan hama, maupun defisiensi nutrisi. Daun tampak segar dengan warna hijau cerah yang merata di seluruh permukaan, memiliki tekstur normal yang tidak layu atau keriting, serta menunjukkan pola pertumbuhan tulang daun yang simetris dan sempurna. Daun yang sehat merupakan indikator utama bahwa tanaman anggur menerima perawatan yang optimal meliputi penyiraman yang cukup dan teratur, pemupukan yang seimbang, paparan sinar matahari yang memadai (minimal 6-8 jam sehari), serta drainase tanah yang baik. Kondisi health check yang positif juga menandakan bahwa program pengendalian hama dan penyakit terpadu (IPM) yang diterapkan sudah berjalan efektif. Tanaman yang konsisten dalam kondisi sehat berpotensi menghasilkan buah anggur dengan kualitas premium baik dari segi rasa, ukuran, kandungan gula, maupun penampilan visual yang menarik untuk dipasarkan.', 'Daun anggur berada dalam kondisi sehat karena tanaman mendapatkan perawatan budidaya yang optimal dan konsisten. Faktor-faktor utama yang menjaga kesehatan tanaman meliputi: penyiraman teratur dengan volume yang tepat (tidak berlebihan maupun kekurangan), pemupukan seimbang yang mencakup unsur makro (Nitrogen, Fosfor, Kalium) dan mikro (Besi, Mangan, Seng, Boron), pH tanah yang optimal antara 5.5-7.0, drainase yang baik untuk mencegah genangan air, paparan cahaya matahari langsung minimal 6-8 jam per hari, pemangkasan rutin untuk menjaga sirkulasi udara pada kanopi, serta penerapan program perlindungan tanaman terpadu (IPM) yang meliputi monitoring berkala, sanitasi kebun, dan penggunaan pestisida secara bijaksana. Kebun anggur yang dikelola dengan standar GAP (Good Agricultural Practices) cenderung memiliki tingkat kesehatan tanaman yang tinggi dan konsisten.', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `hasil_deteksi`
--
ALTER TABLE `hasil_deteksi`
  ADD PRIMARY KEY (`id_deteksi`),
  ADD KEY `id_pengguna` (`id_pengguna`),
  ADD KEY `id_penyakit` (`id_penyakit`);

--
-- Indexes for table `penanganan`
--
ALTER TABLE `penanganan`
  ADD PRIMARY KEY (`id_penanganan`),
  ADD KEY `id_penyakit` (`id_penyakit`);

--
-- Indexes for table `pengguna`
--
ALTER TABLE `pengguna`
  ADD PRIMARY KEY (`id_pengguna`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `penyakit`
--
ALTER TABLE `penyakit`
  ADD PRIMARY KEY (`id_penyakit`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `hasil_deteksi`
--
ALTER TABLE `hasil_deteksi`
  MODIFY `id_deteksi` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT for table `penanganan`
--
ALTER TABLE `penanganan`
  MODIFY `id_penanganan` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `pengguna`
--
ALTER TABLE `pengguna`
  MODIFY `id_pengguna` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `penyakit`
--
ALTER TABLE `penyakit`
  MODIFY `id_penyakit` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `hasil_deteksi`
--
ALTER TABLE `hasil_deteksi`
  ADD CONSTRAINT `hasil_deteksi_ibfk_1` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`) ON DELETE SET NULL,
  ADD CONSTRAINT `hasil_deteksi_ibfk_2` FOREIGN KEY (`id_penyakit`) REFERENCES `penyakit` (`id_penyakit`) ON DELETE CASCADE;

--
-- Constraints for table `penanganan`
--
ALTER TABLE `penanganan`
  ADD CONSTRAINT `penanganan_ibfk_1` FOREIGN KEY (`id_penyakit`) REFERENCES `penyakit` (`id_penyakit`) ON DELETE CASCADE;
--
-- Database: `db_lobster_rnd`
--
CREATE DATABASE IF NOT EXISTS `db_lobster_rnd` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `db_lobster_rnd`;

-- --------------------------------------------------------

--
-- Table structure for table `item_keranjang`
--

CREATE TABLE `item_keranjang` (
  `id` bigint NOT NULL,
  `pengguna_id` bigint NOT NULL,
  `produk_id` bigint NOT NULL,
  `jumlah` int NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Keranjang belanja sementara (sebelum checkout)';

--
-- Dumping data for table `item_keranjang`
--

INSERT INTO `item_keranjang` (`id`, `pengguna_id`, `produk_id`, `jumlah`) VALUES
(54, 5, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `item_pesanan`
--

CREATE TABLE `item_pesanan` (
  `id` bigint NOT NULL,
  `pesanan_id` bigint NOT NULL,
  `produk_id` bigint NOT NULL,
  `jumlah` int NOT NULL,
  `harga_saat_beli` decimal(15,2) NOT NULL,
  `subtotal` decimal(15,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Rincian produk dalam setiap pesanan';

--
-- Dumping data for table `item_pesanan`
--

INSERT INTO `item_pesanan` (`id`, `pesanan_id`, `produk_id`, `jumlah`, `harga_saat_beli`, `subtotal`) VALUES
(1, 1, 2, 2, '350000.00', '700000.00'),
(2, 2, 1, 1, '5000.00', '5000.00'),
(3, 2, 2, 1, '350000.00', '350000.00'),
(4, 2, 3, 1, '45000.00', '45000.00'),
(5, 3, 1, 1, '5000.00', '5000.00'),
(6, 3, 2, 1, '350000.00', '350000.00'),
(7, 4, 1, 1, '5000.00', '5000.00'),
(8, 5, 1, 1, '5000.00', '5000.00'),
(9, 6, 2, 1, '350000.00', '350000.00'),
(10, 7, 2, 1, '350000.00', '350000.00'),
(11, 7, 3, 1, '45000.00', '45000.00'),
(12, 8, 2, 1, '350000.00', '350000.00'),
(13, 9, 2, 1, '350000.00', '350000.00'),
(14, 10, 1, 1, '5000.00', '5000.00'),
(15, 10, 2, 1, '350000.00', '350000.00'),
(16, 11, 1, 2, '5000.00', '10000.00'),
(17, 12, 1, 1, '5000.00', '5000.00'),
(18, 12, 2, 2, '350000.00', '700000.00'),
(19, 12, 3, 1, '45000.00', '45000.00'),
(20, 13, 2, 1, '350000.00', '350000.00'),
(21, 14, 2, 1, '350000.00', '350000.00'),
(22, 15, 2, 1, '350000.00', '350000.00'),
(23, 15, 3, 1, '45000.00', '45000.00'),
(24, 16, 1, 1, '5000.00', '5000.00'),
(25, 16, 2, 1, '350000.00', '350000.00'),
(26, 16, 3, 1, '45000.00', '45000.00'),
(27, 18, 1, 1, '5000.00', '5000.00'),
(28, 19, 2, 1, '350000.00', '350000.00'),
(29, 20, 2, 1, '350000.00', '350000.00'),
(30, 21, 1, 2, '5000.00', '10000.00'),
(31, 22, 1, 1, '5000.00', '5000.00'),
(32, 23, 1, 1, '5000.00', '5000.00'),
(33, 23, 2, 1, '350000.00', '350000.00'),
(34, 24, 3, 1, '45000.00', '45000.00'),
(37, 27, 3, 1, '45000.00', '45000.00'),
(38, 28, 3, 1, '45000.00', '45000.00'),
(39, 29, 3, 1, '45000.00', '45000.00'),
(40, 30, 1, 1, '5000.00', '5000.00'),
(41, 31, 8, 1, '1000000.00', '1000000.00'),
(42, 32, 8, 1, '1000000.00', '1000000.00'),
(43, 33, 2, 1, '350000.00', '350000.00'),
(44, 34, 1, 1, '5000.00', '5000.00'),
(45, 35, 2, 1, '350000.00', '350000.00'),
(46, 36, 8, 1, '1000000.00', '1000000.00');

-- --------------------------------------------------------

--
-- Table structure for table `kategori`
--

CREATE TABLE `kategori` (
  `id` bigint NOT NULL,
  `nama` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `slug` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Kategori pengelompokan produk';

--
-- Dumping data for table `kategori`
--

INSERT INTO `kategori` (`id`, `nama`, `slug`) VALUES
(1, 'bibit', 'bibit'),
(2, 'Konsumsi', 'konsumsi'),
(3, 'Indukan', 'indukan'),
(4, 'paket budidaya', 'paket-budidaya');

-- --------------------------------------------------------

--
-- Table structure for table `pengguna`
--

CREATE TABLE `pengguna` (
  `id` bigint NOT NULL,
  `nama` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `kata_sandi` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `peran` enum('CUSTOMER','ADMIN') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'CUSTOMER'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Menyimpan akun semua pengguna sistem';

--
-- Dumping data for table `pengguna`
--

INSERT INTO `pengguna` (`id`, `nama`, `email`, `kata_sandi`, `peran`) VALUES
(4, 'roy', 'roy@gmail.com', '$2b$10$ke7Mf9a6ZjfTU/s5ue6kUOhUVgPIIkiKVW4oU.v0EAQSP4xiUOWUK', 'ADMIN'),
(5, 'alinda', 'alin@gmail.com', '$2b$10$cTrfmBJDgqdEgokiJi79ieiI0v.Quo9ltNv64sj4Sj1yomSKTEI7i', 'CUSTOMER'),
(6, 'agus', 'agus@gmail.com', '$2b$10$9CxB5a03kB4MDmSAwTl4CuSGWyai0FV1wzyutKZM1AkGKu3t5otla', 'CUSTOMER'),
(7, 'agus1', 'agus1@gmail.com', '$2b$10$iunnR6fuU5GA94oTtAVpSeAATdr6.PUHCxquMyGmrfIFliq65kgay', 'CUSTOMER');

-- --------------------------------------------------------

--
-- Table structure for table `pesanan`
--

CREATE TABLE `pesanan` (
  `id` bigint NOT NULL,
  `pengguna_id` bigint NOT NULL,
  `total_harga` decimal(15,2) NOT NULL,
  `status` enum('MENUNGGU','DIKONFIRMASI','DIKIRIM','SELESAI','DIBATALKAN') NOT NULL DEFAULT 'MENUNGGU',
  `alamat_kirim` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `catatan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `dipesan_pada` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `snap_token` varchar(255) DEFAULT NULL,
  `metode_pembayaran` enum('COD','MIDTRANS') DEFAULT 'MIDTRANS',
  `jasa_kirim` varchar(50) DEFAULT NULL,
  `no_resi` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Transaksi pesanan yang dilakukan customer';

--
-- Dumping data for table `pesanan`
--

INSERT INTO `pesanan` (`id`, `pengguna_id`, `total_harga`, `status`, `alamat_kirim`, `catatan`, `dipesan_pada`, `snap_token`, `metode_pembayaran`, `jasa_kirim`, `no_resi`) VALUES
(1, 4, '700000.00', 'DIBATALKAN', 'Jl. Lobster No. 1', 'Tolong dipacking kayu', '2026-05-09 21:24:47', NULL, 'MIDTRANS', NULL, NULL),
(2, 4, '400000.00', 'SELESAI', 'safsdfasd', 'asdacsd', '2026-05-09 21:29:49', NULL, 'MIDTRANS', NULL, NULL),
(3, 5, '355000.00', 'SELESAI', 'madura', 'kirim cepat', '2026-05-09 21:49:50', NULL, 'MIDTRANS', NULL, NULL),
(4, 4, '5000.00', 'SELESAI', '12313', '12313', '2026-05-09 22:16:20', NULL, 'MIDTRANS', NULL, NULL),
(5, 4, '5000.00', 'DIBATALKAN', '1223', 'qweq', '2026-05-10 10:09:21', NULL, 'MIDTRANS', NULL, NULL),
(6, 4, '350000.00', 'SELESAI', '123', '1233', '2026-05-10 10:11:40', NULL, 'MIDTRANS', NULL, NULL),
(7, 4, '395000.00', 'SELESAI', 'nsdbfhgshbv', 'akmhdhagsd', '2026-05-10 10:15:13', NULL, 'MIDTRANS', NULL, NULL),
(8, 4, '350000.00', 'SELESAI', 'fewfwef', 'aerwr', '2026-05-10 10:20:54', NULL, 'MIDTRANS', NULL, NULL),
(9, 4, '350000.00', 'SELESAI', 'aagag', 'hahahag', '2026-05-12 12:10:25', 'ffda8dbc-aa6d-4556-98e0-0fb9ac7fe705', 'MIDTRANS', NULL, NULL),
(10, 4, '355000.00', 'DIKONFIRMASI', 'sumenep', 'hati hati', '2026-05-12 12:33:41', '5f93d42b-9c01-4c93-a839-9dfa693d26c4', 'MIDTRANS', NULL, NULL),
(11, 6, '10000.00', 'DIKIRIM', 'Jl. Lobster No. 1, Jakarta', 'Tolong pilihkan yang segar', '2026-05-13 20:17:07', '49f03faf-7f74-4469-9934-653e82a7099b', 'MIDTRANS', NULL, NULL),
(12, 5, '750000.00', 'DIKONFIRMASI', 'sumenep', 'carikan yang gemuk', '2026-05-13 20:20:00', 'bb53e07a-331a-4142-abf7-ecee7cfd8d49', 'MIDTRANS', NULL, NULL),
(13, 5, '350000.00', 'DIKONFIRMASI', 'sumenep', 'carikan yang segar', '2026-05-13 20:21:40', '5cd7887b-3155-43c8-94b4-2fd72fea5721', 'MIDTRANS', NULL, NULL),
(14, 5, '350000.00', 'DIKONFIRMASI', 'sumenep', 'carikan yang segar', '2026-05-13 20:22:33', '9e5cf5ed-427b-4e57-a2a8-b033e92a1eed', 'MIDTRANS', NULL, NULL),
(15, 5, '395000.00', 'DIKIRIM', '11', '22', '2026-05-18 17:56:48', NULL, 'MIDTRANS', NULL, NULL),
(16, 5, '400000.00', 'DIKONFIRMASI', '11', '22', '2026-05-18 17:57:25', NULL, 'MIDTRANS', NULL, NULL),
(18, 5, '5000.00', 'DIKONFIRMASI', 'test alamat', 'test catatan', '2026-05-18 18:04:26', '1aeb3008-a556-4125-b143-8c5303d251e9', 'MIDTRANS', NULL, NULL),
(19, 5, '350000.00', 'DIKONFIRMASI', 'uih', 'jhjh', '2026-05-18 18:06:21', '5f1139c0-c30c-4b66-998d-620de7816e22', 'MIDTRANS', NULL, NULL),
(20, 4, '350000.00', 'DIKONFIRMASI', 'gasfdgfad', 'aksdgjhasgjd', '2026-05-19 11:16:33', '49b06612-8842-48db-b028-3a856afc90d4', 'MIDTRANS', NULL, NULL),
(21, 6, '10000.00', 'MENUNGGU', 'Jl. Kerapu No. 12, Surabaya', 'Kirim sore hari', '2026-05-20 08:56:43', '85dac924-d909-454b-886d-a01b5d621bdb', 'MIDTRANS', NULL, NULL),
(22, 4, '5000.00', 'MENUNGGU', 'sumenep', 'hati hati', '2026-05-20 09:32:35', NULL, 'COD', NULL, NULL),
(23, 5, '355000.00', 'MENUNGGU', 'sumenep', 'roy', '2026-05-21 18:42:20', NULL, 'COD', NULL, NULL),
(24, 5, '45000.00', 'MENUNGGU', 'roy', 'qqq', '2026-05-21 18:52:30', NULL, 'COD', NULL, NULL),
(27, 5, '45000.00', 'MENUNGGU', 'zz', 'z', '2026-05-21 18:56:41', '3b61ff85-9d58-42ef-9e29-266ec877b369', 'MIDTRANS', NULL, NULL),
(28, 5, '45000.00', 'MENUNGGU', 'aaa', '', '2026-05-21 18:57:10', '08272f93-efb5-4c47-a2a5-d3fb5883e263', 'MIDTRANS', NULL, NULL),
(29, 5, '45000.00', 'DIKONFIRMASI', 'xxx', '', '2026-05-21 18:58:46', '62dbb995-9a3d-4a16-8946-b8f2f9cb875f', 'MIDTRANS', NULL, NULL),
(30, 4, '5000.00', 'DIKONFIRMASI', 'pamekasan', 'hati hati', '2026-05-25 20:27:26', '40c22007-c9e7-4aa1-abcb-c41525f87b4a', 'MIDTRANS', NULL, NULL),
(31, 5, '1000000.00', 'DIKIRIM', 'Jalan Raya Indah No. 12, Jakarta', '', '2026-05-26 11:28:43', NULL, 'COD', 'J&T', 'JT99882233'),
(32, 4, '1000000.00', 'DIKIRIM', 'jalan jatimas pangarangan no33 sumenep ', '-', '2026-05-26 11:38:03', NULL, 'COD', 'J&T', 'JT99882233'),
(33, 4, '350000.00', 'DIKONFIRMASI', 'jalan jatimas pangarangan', '--', '2026-05-26 11:43:25', NULL, 'COD', 'JNE', 'JNE7615234'),
(34, 4, '5000.00', 'DIKONFIRMASI', 'aaaaa', 'aaa', '2026-05-26 11:52:31', NULL, 'COD', 'JNE', 'JNE31242526'),
(35, 4, '350000.00', 'DIKONFIRMASI', 'jalan perkasa 5', '-', '2026-05-26 12:15:43', 'c8ce909a-0058-406a-900b-055403bfaff8', 'MIDTRANS', 'JNE', 'jne514251243'),
(36, 5, '1000000.00', 'DIKIRIM', 'Rumah anggris', '', '2026-05-26 12:24:50', '004cd727-65f5-4f20-99fa-f44bce54a35f', 'MIDTRANS', 'JNE', 'JNE736546456');

-- --------------------------------------------------------

--
-- Table structure for table `produk`
--

CREATE TABLE `produk` (
  `id` bigint NOT NULL,
  `kategori_id` bigint NOT NULL,
  `nama` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `deskripsi` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `harga` decimal(15,2) NOT NULL,
  `stok` int NOT NULL DEFAULT '0',
  `url_gambar` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `dibuat_pada` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `diubah_pada` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Data semua produk yang dijual di toko';

--
-- Dumping data for table `produk`
--

INSERT INTO `produk` (`id`, `kategori_id`, `nama`, `deskripsi`, `harga`, `stok`, `url_gambar`, `dibuat_pada`, `diubah_pada`) VALUES
(1, 1, 'Bibit Lobster Air Tawar', 'Bibit lobster air tawar jenis Clarkii/Red Claw kualitas unggul. Ukuran 1-2 inci, kondisi sehat dan lincah. Cocok untuk pemula yang ingin mulai budidaya.', '5000.00', 984, '/bibit.png', '2026-05-07 21:14:43', '2026-05-26 11:52:31'),
(2, 3, 'Indukan Lobster Super', 'Paket indukan lobster siap pijah. Terdiri dari 5 betina dan 3 jantan ukuran 4-5 inci. Sudah melalui seleksi ketat untuk hasil anakan yang maksimal.', '350000.00', 5, '/indukan.png', '2026-05-07 21:14:43', '2026-05-26 12:15:43'),
(3, 2, 'Lobster Air Tawar Konsumsi', 'Lobster air tawar segar ukuran konsumsi (1kg isi 8-10 ekor). Daging padat, manis, dan bergizi tinggi. Dikirim dalam keadaan hidup/segar.', '45000.00', 89, '/konsumsi.png', '2026-05-07 21:14:43', '2026-05-21 18:58:46'),
(8, 4, 'Paket Budidaya ', 'mendapatkan 1 kolam terpal, 1set indukan siap telur, pelatihan dan penjelasan, pakan lobster, shelter untuk lobster', '1000000.00', 2, '/images/1779768714474-362556205.png', '2026-05-26 11:13:35', '2026-05-26 12:24:50');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `item_keranjang`
--
ALTER TABLE `item_keranjang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_keranjang_produk` (`pengguna_id`,`produk_id`),
  ADD KEY `fk_keranjang_produk` (`produk_id`);

--
-- Indexes for table `item_pesanan`
--
ALTER TABLE `item_pesanan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_item_pesanan` (`pesanan_id`),
  ADD KEY `fk_item_produk` (`produk_id`);

--
-- Indexes for table `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_slug` (`slug`);

--
-- Indexes for table `pengguna`
--
ALTER TABLE `pengguna`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_email` (`email`);

--
-- Indexes for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_pesanan_pengguna` (`pengguna_id`);

--
-- Indexes for table `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_produk_kategori` (`kategori_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `item_keranjang`
--
ALTER TABLE `item_keranjang`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `item_pesanan`
--
ALTER TABLE `item_pesanan`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `kategori`
--
ALTER TABLE `kategori`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `pengguna`
--
ALTER TABLE `pengguna`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `pesanan`
--
ALTER TABLE `pesanan`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `produk`
--
ALTER TABLE `produk`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `item_keranjang`
--
ALTER TABLE `item_keranjang`
  ADD CONSTRAINT `fk_keranjang_pengguna` FOREIGN KEY (`pengguna_id`) REFERENCES `pengguna` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_keranjang_produk` FOREIGN KEY (`produk_id`) REFERENCES `produk` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `item_pesanan`
--
ALTER TABLE `item_pesanan`
  ADD CONSTRAINT `fk_item_pesanan` FOREIGN KEY (`pesanan_id`) REFERENCES `pesanan` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_item_produk` FOREIGN KEY (`produk_id`) REFERENCES `produk` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD CONSTRAINT `fk_pesanan_pengguna` FOREIGN KEY (`pengguna_id`) REFERENCES `pengguna` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `produk`
--
ALTER TABLE `produk`
  ADD CONSTRAINT `fk_produk_kategori` FOREIGN KEY (`kategori_id`) REFERENCES `kategori` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
--
-- Database: `toko_online`
--
CREATE DATABASE IF NOT EXISTS `toko_online` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `toko_online`;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
