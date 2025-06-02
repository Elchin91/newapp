@echo off
echo 🧹 Очищаем файлы сборки...

if exist build (
    rmdir /s /q build
    echo ✅ Папка build удалена
)

if exist iOS_App (
    cd iOS_App
    xcodebuild clean -project iSponsorBlockTV.xcodeproj -scheme iSponsorBlockTV 2>nul
    cd ..
)

echo ✅ Очистка завершена
pause
