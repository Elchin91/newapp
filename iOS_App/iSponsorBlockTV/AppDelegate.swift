import UIKit
import Python

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Инициализация Python окружения
        setupPythonEnvironment()
        
        // Настройка фоновых задач
        setupBackgroundTasks()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Python Environment Setup
    
    private func setupPythonEnvironment() {
        // Получаем путь к Python ресурсам в bundle
        guard let pythonResourcesPath = Bundle.main.path(forResource: "PythonResources", ofType: nil) else {
            print("❌ Не найдены Python ресурсы в bundle")
            return
        }
        
        // Настраиваем Python путь
        let pythonPath = "\(pythonResourcesPath)/lib/python3.11"
        let sitePath = "\(pythonResourcesPath)/lib/python3.11/site-packages"
        
        // Устанавливаем переменные окружения для Python
        setenv("PYTHONPATH", "\(pythonPath):\(sitePath)", 1)
        setenv("PYTHONHOME", pythonResourcesPath, 1)
        
        // Инициализируем Python
        Py_Initialize()
        
        print("✅ Python окружение инициализировано")
        print("📁 Python путь: \(pythonPath)")
    }
    
    // MARK: - Background Tasks
    
    private func setupBackgroundTasks() {
        // Регистрируем фоновую задачу для синхронизации
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "tv.sponsorblock.iSponsorBlockTV.background-sync", using: nil) { task in
            self.handleBackgroundSync(task: task as! BGProcessingTask)
        }
    }
    
    private func handleBackgroundSync(task: BGProcessingTask) {
        // Планируем следующую фоновую задачу
        scheduleBackgroundSync()
        
        // Выполняем синхронизацию в фоне
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        // Здесь можно добавить логику фоновой синхронизации
        DispatchQueue.global(qos: .background).async {
            // Выполняем фоновые задачи
            task.setTaskCompleted(success: true)
        }
    }
    
    private func scheduleBackgroundSync() {
        let request = BGProcessingTaskRequest(identifier: "tv.sponsorblock.iSponsorBlockTV.background-sync")
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // 15 минут
        
        try? BGTaskScheduler.shared.submit(request)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Планируем фоновую задачу при переходе в фон
        scheduleBackgroundSync()
    }
} 