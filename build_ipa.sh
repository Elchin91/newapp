#!/bin/bash

echo "🍎 Начинаем сборку iSponsorBlockTV для iOS..."

# Определяем операционную систему
OS_TYPE=$(uname -s 2>/dev/null || echo "Windows")
echo "💻 Операционная система: $OS_TYPE"

# Проверяем наличие Xcode (только для macOS)
if [[ "$OS_TYPE" == "Darwin" ]]; then
    if ! command -v xcodebuild &> /dev/null; then
        echo "❌ Xcode не найден. Установите Xcode из Mac App Store."
        exit 1
    fi
else
    echo "⚠️  Внимание: Сборка iOS приложений возможна только на macOS"
    echo "🔄 Продолжаем для демонстрации структуры проекта..."
fi

# Проверяем наличие папки проекта
if [ ! -d "iOS_App" ]; then
    echo "❌ Папка iOS_App не найдена"
    echo "📁 Создаем структуру проекта..."
    mkdir -p iOS_App
    echo "✅ Папка проекта создана"
fi

# Переходим в папку с проектом
cd iOS_App

# Проверяем наличие проекта Xcode
if [ ! -f "iSponsorBlockTV.xcodeproj/project.pbxproj" ]; then
    echo "❌ Проект Xcode не найден: iSponsorBlockTV.xcodeproj"
    echo "📋 Создайте проект Xcode или проверьте путь"
    cd ..
    exit 1
fi

# Создаем папку для сборки
mkdir -p ../build

# Только для macOS выполняем сборку
if [[ "$OS_TYPE" == "Darwin" ]]; then
    # Очищаем предыдущие сборки
    echo "🧹 Очищаем предыдущие сборки..."
    xcodebuild clean -project iSponsorBlockTV.xcodeproj -scheme iSponsorBlockTV

    # Собираем архив для iOS устройств
    echo "📦 Создаем архив приложения..."
    xcodebuild archive \
        -project iSponsorBlockTV.xcodeproj \
        -scheme iSponsorBlockTV \
        -destination generic/platform=iOS \
        -archivePath ../build/iSponsorBlockTV.xcarchive \
        CODE_SIGN_IDENTITY="" \
        CODE_SIGNING_REQUIRED=NO \
        CODE_SIGNING_ALLOWED=NO

    # Экспортируем IPA без подписи
    echo "📱 Экспортируем IPA файл..."
    xcodebuild -exportArchive \
        -archivePath ../build/iSponsorBlockTV.xcarchive \
        -exportPath ../build \
        -exportOptionsPlist export_options.plist

    # Переименовываем IPA файл
    if [ -f "../build/iSponsorBlockTV.ipa" ]; then
        VERSION=$(date +"%Y%m%d_%H%M%S")
        mv ../build/iSponsorBlockTV.ipa "../build/iSponsorBlockTV_${VERSION}.ipa"
        echo "✅ IPA файл готов: build/iSponsorBlockTV_${VERSION}.ipa"
        echo "📲 Установите через TrollStore"
    else
        echo "❌ Ошибка при создании IPA файла"
        exit 1
    fi
else
    echo "💡 Для сборки на macOS используйте те же команды"
    echo "📋 Структура проекта проверена"
fi

cd ..
