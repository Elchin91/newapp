# iSponsorBlockTV for iOS

iOS приложение для блокировки спонсорских сегментов в видео на Samsung TV.

## 🚀 Автоматическая сборка

### GitHub Actions
Проект автоматически собирается через GitHub Actions на каждый push:
- ✅ Используется macOS runner с Xcode
- 📦 IPA файл доступен в Artifacts
- 🏷️ Релизы создаются автоматически

### Локальная сборка

#### macOS
```bash
make build
```

#### Windows
```bash
./build.bat
```

## 📲 Установка

### Через TrollStore
1. Скачайте IPA из [Releases](../../releases)
2. Перенесите на iPhone
3. Откройте через TrollStore
4. Нажмите Install

## 🛠️ Разработка

```bash
# Настройка окружения (macOS)
make dev-setup

# Сборка
make build

# Очистка
make clean

# Справка
make help
```

## 📁 Структура проекта

```
├── .github/workflows/    # GitHub Actions
├── iOS_App/             # Xcode проект
├── build_ipa.sh         # Скрипт сборки
├── Makefile            # Make команды
└── *.bat               # Windows скрипты
```

## 📞 Поддержка

- **Issues** - [GitHub Issues](../../issues)
- **Telegram** - [@iSponsorBlockTV](https://t.me/iSponsorBlockTV)

---

**Наслаждайтесь YouTube без рекламы! 🎉**

