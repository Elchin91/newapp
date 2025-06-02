.PHONY: build clean install help

# Переменные
PROJECT_DIR = iOS_App
BUILD_DIR = build
IPA_NAME = iSponsorBlockTV

help: ## Показать справку
	@echo "📱 iSponsorBlockTV iOS Build System"
	@echo ""
	@echo "🪟 Для Windows пользователей:"
	@echo "  - Используйте: build.bat"
	@echo "  - Или установите make: choco install make"
	@echo ""
	@echo "Доступные команды:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: ## Собрать IPA файл
	@echo "🍎 Начинаем сборку iOS приложения..."
	@chmod +x build_ipa.sh
	@./build_ipa.sh

clean: ## Очистить файлы сборки
	@echo "🧹 Очищаем файлы сборки..."
	@rm -rf $(BUILD_DIR)
	@cd $(PROJECT_DIR) && xcodebuild clean -project $(IPA_NAME).xcodeproj -scheme $(IPA_NAME) 2>/dev/null || true
	@echo "✅ Очистка завершена"

install: build ## Показать инструкцию по установке
	@echo ""
	@echo "📲 Для установки на iPhone через TrollStore:"
	@echo "1. Перенесите IPA файл на iPhone"
	@echo "2. Откройте файл и выберите TrollStore"
	@echo "3. Нажмите Install"
	@echo ""
	@ls -la $(BUILD_DIR)/*.ipa 2>/dev/null || echo "❌ IPA файл не найден"

# Установка зависимостей для разработки
dev-setup: ## Настроить окружение для разработки
	@echo "🔧 Настраиваем окружение для разработки..."
	@echo "✅ Убедитесь что установлен Xcode"
	@xcode-select --install 2>/dev/null || echo "Command Line Tools уже установлены"

windows-setup: ## Установить make для Windows
	@echo "🪟 Установка make для Windows..."
	@echo "Выберите один из способов:"
	@echo "1. Через Chocolatey: choco install make"
	@echo "2. Через Scoop: scoop install make"
	@echo "3. Используйте build.bat вместо make build"
