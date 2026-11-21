@echo off
chcp 65001 > nul
set "MODEL_TAG=hf.co/huihui-ai/Huihui-Qwen3.8-27B-abliterated-GGUF:UD-Q4_K_XL"

echo ========================================================
echo [Huihui-AI] Запуск установки модели...
echo ========================================================

:: 1. Проверяем, установлена ли Ollama
where ollama > nul 2>&1
if %errorlevel% neq 0 (
    if exist "%LOCALAPPDATA%\Programs\Ollama\ollama.exe" (
        set "PATH=%PATH%;%LOCALAPPDATA%\Programs\Ollama"
    ) else (
        echo [ОШИБКА] Установите Ollama для продолжения!
        exit /b 1
    )
)

:: 2. Запускаем фоновый сервер Ollama, если не запущен
tasklist /FI "IMAGENAME eq ollama.exe" 2>NUL | find /I /N "ollama.exe" > NUL
if %errorlevel% neq 0 (
    echo [INFO] Запуск фонового сервера Ollama...
    start "" /B ollama serve
    timeout /t 3 /nobreak > nul
)

:: 3. Скачиваем модель Huihui-AI
echo [СКАЧИВАНИЕ] Проверка / загрузка модели %MODEL_TAG%...
ollama pull %MODEL_TAG%

if %errorlevel% neq 0 (
    echo [ОШИБКА] Сбой при скачивании модели %MODEL_TAG%!
    exit /b 1
)

:: 4. Передаём тег модели в Python-лаунчер для активации Web-чата
echo [MODEL_TAG] %MODEL_TAG%
echo [ГОТОВО] Модель Huihui-AI готова к работе!
exit /b 0
