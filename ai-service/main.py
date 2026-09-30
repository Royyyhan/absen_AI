"""
AI Face Recognition Microservice
=================================
Microservice mandiri (self-hosted) untuk verifikasi wajah menggunakan
FastAPI dan DeepFace dengan model Facenet512 dan metrik cosine.

Endpoint:
  POST /compare  — Menerima dua gambar (captured_image & master_image)
                    dan mengembalikan hasil verifikasi wajah.

Jalankan:
  uvicorn main:app --host 0.0.0.0 --port 8000 --reload
"""

import os
import sys
import uuid
import shutil
import logging
from contextlib import asynccontextmanager

# Pastikan UTF-8 encoding untuk console Windows
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")
if hasattr(sys.stderr, "reconfigure"):
    sys.stderr.reconfigure(encoding="utf-8")

from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.responses import JSONResponse
from PIL import Image, ImageOps
from deepface import DeepFace

# ──────────────────────────────────────────────
# Konfigurasi Logging
# ──────────────────────────────────────────────
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s  [%(levelname)s]  %(message)s",
)
logger = logging.getLogger(__name__)

# ──────────────────────────────────────────────
# Direktori untuk file sementara
# ──────────────────────────────────────────────
TEMP_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "temp")

# ──────────────────────────────────────────────
# Model yang digunakan (pre-load saat startup)
# ──────────────────────────────────────────────
MODEL_NAME = "Facenet512"
DISTANCE_METRIC = "cosine"
DETECTOR_BACKEND = "retinaface"

# ════════════════════════════════════════════════════════════════════════
# 🎯 PENGATURAN TINGKAT AKURASI / KEMIRIPAN WAJAH (0 s/d 100%)
# ════════════════════════════════════════════════════════════════════════
MIN_CONFIDENCE_PERCENT = 65.0


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Lifespan handler — dipanggil saat server startup & shutdown.
    Digunakan untuk pre-load model DeepFace agar request pertama tidak lambat.
    """
    # ── Startup ──
    os.makedirs(TEMP_DIR, exist_ok=True)
    logger.info("📁 Direktori temp siap: %s", TEMP_DIR)

    logger.info("⏳ Memuat model %s & detector %s ...", MODEL_NAME, DETECTOR_BACKEND)
    try:
        DeepFace.build_model(MODEL_NAME)
        logger.info("✅ Model %s & %s siap digunakan.", MODEL_NAME, DETECTOR_BACKEND)
    except Exception as exc:
        logger.warning("⚠️ Gagal pre-load model: %s (akan dimuat saat request pertama)", exc)

    yield  # ← Server berjalan di sini

    # ── Shutdown ──
    # Bersihkan folder temp jika masih ada sisa file
    if os.path.exists(TEMP_DIR):
        shutil.rmtree(TEMP_DIR, ignore_errors=True)
        logger.info("🧹 Direktori temp dibersihkan.")


# ──────────────────────────────────────────────
# Inisialisasi FastAPI App
# ──────────────────────────────────────────────
app = FastAPI(
    title="Face Recognition Microservice",
    description="Verifikasi wajah menggunakan DeepFace (Facenet512 + Cosine)",
    version="1.0.0",
    lifespan=lifespan,
)


# ──────────────────────────────────────────────
# Helper: Simpan UploadFile ke disk sementara
# ──────────────────────────────────────────────
async def save_temp_file(upload: UploadFile) -> str:
    """Simpan UploadFile ke folder temp, koreksi rotasi EXIF, dan kembalikan path absolutnya."""
    ext = os.path.splitext(upload.filename or "image.jpg")[1] or ".jpg"
    filename = f"{uuid.uuid4().hex}{ext}"
    filepath = os.path.join(TEMP_DIR, filename)

    contents = await upload.read()
    with open(filepath, "wb") as f:
        f.write(contents)

    # Pastikan orientasi foto tegak (normalisasi rotasi EXIF dari kamera HP/selfie)
    try:
        with Image.open(filepath) as img:
            transposed = ImageOps.exif_transpose(img)
            if transposed is not None and transposed != img:
                transposed.save(filepath, quality=95)
    except Exception as rot_err:
        logger.debug("Info orientasi EXIF: %s", rot_err)

    return filepath


def cleanup_files(*paths: str):
    """Hapus file-file sementara dari disk."""
    for p in paths:
        try:
            if p and os.path.exists(p):
                os.remove(p)
        except OSError:
            pass


# ──────────────────────────────────────────────
# Health Check
# ──────────────────────────────────────────────
@app.get("/")
async def health_check():
    return {
        "success": True,
        "message": "Face Recognition Microservice berjalan.",
        "model": MODEL_NAME,
        "detector": DETECTOR_BACKEND,
        "metric": DISTANCE_METRIC,
    }


# ──────────────────────────────────────────────
# Endpoint Utama: POST /compare
# ──────────────────────────────────────────────
@app.post("/compare")
async def compare_faces(
    captured_image: UploadFile = File(..., description="Foto wajah yang baru diambil (absensi)"),
    master_image: UploadFile = File(..., description="Foto master / referensi wajah user"),
):
    """
    Membandingkan dua gambar wajah dan mengembalikan hasil verifikasi.

    Returns:
        JSON:
            - success  (bool) : Apakah proses berhasil tanpa error
            - verified (bool) : Apakah wajah cocok
            - distance (float): Jarak cosine antar embedding wajah
            - confidence (float): Skor kemiripan 0 – 100
    """
    captured_path: str | None = None
    master_path: str | None = None

    try:
        # 1. Simpan file yang diupload ke disk sementara
        captured_path = await save_temp_file(captured_image)
        master_path = await save_temp_file(master_image)

        logger.info(
            "🔍 Memproses verifikasi wajah — captured: %s, master: %s",
            os.path.basename(captured_path),
            os.path.basename(master_path),
        )

        # 2. Jalankan verifikasi dengan DeepFace (RetinaFace + Facenet512)
        result = DeepFace.verify(
            img1_path=captured_path,
            img2_path=master_path,
            model_name=MODEL_NAME,
            distance_metric=DISTANCE_METRIC,
            detector_backend=DETECTOR_BACKEND,
            enforce_detection=False,
            align=True,
        )

        # 3. Ekstrak hasil
        distance: float = round(result.get("distance", 1.0), 6)

        # Hitung skor kemiripan wajah (0 s/d 100%)
        # Untuk cosine distance: 0.0 = 100% cocok, 1.0 = 0% cocok
        raw_confidence = (1.0 - distance) * 100.0
        confidence = round(max(0.0, min(100.0, raw_confidence)), 2)

        # Wajah dinyatakan COCOK jika skor kemiripan >= MIN_CONFIDENCE_PERCENT
        verified: bool = bool(confidence >= MIN_CONFIDENCE_PERCENT)

        logger.info(
            "✅ Hasil verifikasi — verified=%s, confidence=%.2f%% (Minimal: %.2f%%), distance=%.6f",
            verified, confidence, MIN_CONFIDENCE_PERCENT, distance,
        )

        return JSONResponse(content={
            "success": True,
            "verified": verified,
            "distance": distance,
            "threshold": MIN_CONFIDENCE_PERCENT,
            "confidence": confidence,
        })

    except ValueError as ve:
        # DeepFace melempar ValueError jika wajah tidak terdeteksi
        error_msg = str(ve)
        logger.warning("⚠️ Wajah tidak terdeteksi: %s", error_msg)
        return JSONResponse(
            status_code=400,
            content={
                "success": False,
                "verified": False,
                "distance": None,
                "confidence": 0.0,
                "error": "Wajah tidak terdeteksi pada gambar. Pastikan foto menampilkan wajah dengan jelas.",
            },
        )

    except Exception as exc:
        logger.error("❌ Error saat verifikasi wajah: %s", exc, exc_info=True)
        return JSONResponse(
            status_code=500,
            content={
                "success": False,
                "verified": False,
                "distance": None,
                "confidence": 0.0,
                "error": f"Terjadi kesalahan saat memproses verifikasi wajah: {str(exc)}",
            },
        )

    finally:
        # 4. Selalu hapus file sementara setelah pemrosesan selesai
        cleanup_files(captured_path, master_path)
        logger.info("🧹 File sementara dibersihkan.")


# ──────────────────────────────────────────────
# Entry point (untuk menjalankan langsung: python main.py)
# ──────────────────────────────────────────────
if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
    )
