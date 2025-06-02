@echo off
echo 🍎 Начинаем сборку iOS приложения...

if not exist build_ipa.sh (
    echo ❌ Файл build_ipa.sh не найден
    pause
    exit /b 1
)

bash build_ipa.sh

if %ERRORLEVEL% NEQ 0 (
    echo ❌ Ошибка при сборке
    pause
    exit /b 1
)

echo ✅ Сборка завершена
pause
