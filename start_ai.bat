@echo off
title AI Face Recognition Service (Port 8000)
echo ============================================================
echo   Menjalankan AI Face Recognition Service (DeepFace FastAPI)
echo   Host: http://0.0.0.0:8000
echo ============================================================
cd /d "%~dp0ai-service"
call venv\Scripts\activate.bat
python -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload
pause
