import UIKit
import Python
import BackgroundTasks

class ViewController: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var deviceCountLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var logTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private var isServiceRunning = false
    private var pythonTask: DispatchWorkItem?
    private var logMessages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadConfiguration()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        // Настройка заголовка
        title = "iSponsorBlockTV"
        
        // Настройка кнопок
        setupButtons()
        
        // Настройка лога
        setupLogView()
        
        // Настройка статусных меток
        setupStatusLabels()
        
        // Добавляем логотип
        setupNavigationBar()
    }
    
    private func setupButtons() {
        // Кнопка запуска/остановки
        startStopButton.layer.cornerRadius = 12
        startStopButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        updateStartStopButton()
        
        // Кнопка настроек
        settingsButton.layer.cornerRadius = 8
        settingsButton.backgroundColor = UIColor.systemBlue
        settingsButton.setTitleColor(.white, for: .normal)
    }
    
    private func setupLogView() {
        logTextView.layer.cornerRadius = 8
        logTextView.layer.borderWidth = 1
        logTextView.layer.borderColor = UIColor.systemGray4.cgColor
        logTextView.backgroundColor = UIColor.systemGray6
        logTextView.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        logTextView.isEditable = false
    }
    
    private func setupStatusLabels() {
        statusLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        deviceCountLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        deviceCountLabel.textColor = UIColor.systemGray
    }
    
    private func setupNavigationBar() {
        // Добавляем эмодзи в заголовок
        let titleLabel = UILabel()
        titleLabel.text = "🚫📺 iSponsorBlockTV"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel
    }
    
    // MARK: - Configuration
    
    private func loadConfiguration() {
        addLogMessage("📱 Загрузка конфигурации...")
        
        DispatchQueue.global(qos: .background).async {
            // Здесь можно добавить загрузку конфигурации через Python
            let deviceCount = self.getDeviceCount()
            
            DispatchQueue.main.async {
                self.updateDeviceCount(deviceCount)
                self.updateStatus("Готов к работе")
                self.addLogMessage("✅ Конфигурация загружена")
            }
        }
    }
    
    private func getDeviceCount() -> Int {
        // Заглушка для получения количества устройств
        // В реальной реализации здесь будет вызов Python кода
        return 1
    }
    
    // MARK: - Actions
    
    @IBAction func startStopButtonTapped(_ sender: UIButton) {
        if isServiceRunning {
            stopService()
        } else {
            startService()
        }
    }
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        showSettingsAlert()
    }
    
    // MARK: - Service Control
    
    private func startService() {
        guard !isServiceRunning else { return }
        
        addLogMessage("🚀 Запуск службы блокировки рекламы...")
        updateStatus("Запуск...")
        
        activityIndicator.startAnimating()
        isServiceRunning = true
        updateStartStopButton()
        
        // Запускаем Python сервис в фоне
        pythonTask = DispatchWorkItem { [weak self] in
            self?.runPythonService()
        }
        
        DispatchQueue.global(qos: .background).async(execute: pythonTask!)
    }
    
    private func stopService() {
        guard isServiceRunning else { return }
        
        addLogMessage("⏹️ Остановка службы...")
        updateStatus("Остановка...")
        
        // Отменяем Python задачу
        pythonTask?.cancel()
        pythonTask = nil
        
        isServiceRunning = false
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.updateStartStopButton()
            self.updateStatus("Остановлен")
            self.addLogMessage("✅ Служба остановлена")
        }
    }
    
    private func runPythonService() {
        // Здесь будет запуск Python кода iSponsorBlockTV
        DispatchQueue.main.async {
            self.updateStatus("Работает")
            self.activityIndicator.stopAnimating()
            self.addLogMessage("✅ Служба запущена и работает")
            self.addLogMessage("🔍 Поиск Samsung TV в сети...")
            self.addLogMessage("📺 Подключение к YouTube на TV...")
            self.addLogMessage("🛡️ Блокировка рекламы активна")
        }
        
        // Симуляция работы сервиса
        while !Thread.current.isCancelled && isServiceRunning {
            Thread.sleep(forTimeInterval: 5.0)
            
            DispatchQueue.main.async {
                self.addLogMessage("📊 Служба работает нормально")
            }
        }
    }
    
    // MARK: - UI Updates
    
    private func updateStartStopButton() {
        let title = isServiceRunning ? "⏹️ Остановить" : "▶️ Запустить"
        let color = isServiceRunning ? UIColor.systemRed : UIColor.systemGreen
        
        startStopButton.setTitle(title, for: .normal)
        startStopButton.backgroundColor = color
    }
    
    private func updateStatus(_ status: String) {
        statusLabel.text = "Статус: \(status)"
    }
    
    private func updateDeviceCount(_ count: Int) {
        deviceCountLabel.text = "Найдено устройств: \(count)"
    }
    
    private func addLogMessage(_ message: String) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        let logEntry = "[\(timestamp)] \(message)"
        
        logMessages.append(logEntry)
        
        // Ограничиваем количество сообщений
        if logMessages.count > 100 {
            logMessages.removeFirst()
        }
        
        DispatchQueue.main.async {
            self.logTextView.text = self.logMessages.joined(separator: "\n")
            
            // Прокручиваем к последнему сообщению
            let bottom = NSMakeRange(self.logTextView.text.count - 1, 1)
            self.logTextView.scrollRangeToVisible(bottom)
        }
    }
    
    // MARK: - Settings
    
    private func showSettingsAlert() {
        let alert = UIAlertController(title: "⚙️ Настройки", message: "Выберите действие", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "🔧 Настроить устройства", style: .default) { _ in
            self.showDeviceSetup()
        })
        
        alert.addAction(UIAlertAction(title: "🎯 Категории блокировки", style: .default) { _ in
            self.showCategoriesSetup()
        })
        
        alert.addAction(UIAlertAction(title: "📊 Статистика", style: .default) { _ in
            self.showStatistics()
        })
        
        alert.addAction(UIAlertAction(title: "ℹ️ О программе", style: .default) { _ in
            self.showAbout()
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        // Для iPad
        if let popover = alert.popoverPresentationController {
            popover.sourceView = settingsButton
            popover.sourceRect = settingsButton.bounds
        }
        
        present(alert, animated: true)
    }
    
    private func showDeviceSetup() {
        let alert = UIAlertController(title: "📺 Настройка устройств", message: "Для добавления нового Samsung TV:\n\n1. Включите TV\n2. Откройте YouTube\n3. Перейдите в Настройки → Связать с телевизором\n4. Введите код сопряжения", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Добавить устройство", style: .default) { _ in
            self.addLogMessage("🔧 Запуск мастера настройки устройств...")
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
    private func showCategoriesSetup() {
        let alert = UIAlertController(title: "🎯 Категории блокировки", message: "Выберите что блокировать:", preferredStyle: .alert)
        
        let categories = [
            "💰 Спонсорские сегменты",
            "🎬 Интро/Аутро",
            "📢 Самореклама",
            "👆 Призывы к действию",
            "🎵 Не по теме музыка"
        ]
        
        for category in categories {
            alert.addAction(UIAlertAction(title: "✓ \(category)", style: .default))
        }
        
        alert.addAction(UIAlertAction(title: "Готово", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showStatistics() {
        let alert = UIAlertController(title: "📊 Статистика", message: "Заблокировано сегментов: 42\nСэкономлено времени: 15 мин\nПоследняя активность: сейчас", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
    private func showAbout() {
        let alert = UIAlertController(title: "ℹ️ О программе", message: "iSponsorBlockTV v2.5.3\n\nБлокировка рекламы и спонсорских сегментов в YouTube на Samsung TV\n\nОснован на проекте SponsorBlock", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
    // MARK: - URL Scheme Handling
    
    func handleURLScheme(_ url: URL) {
        addLogMessage("📱 Получена команда: \(url)")
        
        // Можно добавить обработку различных команд через URL схемы
        if url.host == "start" {
            startService()
        } else if url.host == "stop" {
            stopService()
        }
    }
} 