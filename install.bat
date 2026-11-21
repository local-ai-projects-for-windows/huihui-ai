@echo off
chcp 65001 > nul
set "MODEL_TAG=hf.co/huihui-ai/Huihui-Qwen3.8-27B-abliterated-GGUF:UD-Q4_K_XL"

echo ========================================================
echo [Huihui-AI] Запуск автоматической установки модели...
echo ========================================================

:: 1. Проверяем, установлена ли Ollama
where ollama > nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Ollama не найдена. Скачивание установщика...
    curl -L -o "%TEMP%\OllamaSetup.exe" "https://ollama.com"
    if %errorlevel% neq 0 (
        echo [ОШИБКА] Не удалось скачать OllamaSetup.exe!
        exit /b 1
    )
    echo [INFO] Установка Ollama...
    start /wait "" "%TEMP%\OllamaSetup.exe" /VERYSILENT /NORESTART
    
    :: Обновляем путь к ollama для текущей сессии
    set "PATH=%PATH%;%LOCALAPPDATA%\Programs\Ollama"
)

:: 2. Проверяем и запускаем фоновый сервер Ollama
tasklist /FI "IMAGENAME eq ollama.exe" 2>NUL | find /I /N "ollama.exe" > NUL
if %errorlevel% neq 0 (
    echo [INFO] Запуск фонового сервера Ollama...
    start "" /B ollama serve
    timeout /t 3 /nobreak > nul
)

:: 3. Скачиваем модель Huihui-AI
echo [СКАЧИВАНИЕ] Загрузка модели %MODEL_TAG%...
echo [INFO] Это может занять несколько минут в зависимости от скорости интернета...
ollama pull %MODEL_TAG%

if %errorlevel% neq 0 (
    echo [ОШИБКА] Сбой при скачивании модели %MODEL_TAG%!
    exit /b 1
)

:: 4. Передаём тег модели обратно в Python-лаунчер для активации Web-чата
echo [MODEL_TAG] %MODEL_TAG%
echo [ГОТОВО] Модель Huihui-AI успешно установлена и запущена в фоне!
exit /b 0
