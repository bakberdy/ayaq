import UIKit
import os.log

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    private let container = DependencyContainer()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "ayaq", category: "SceneDelegate")

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        logger.info("🪟 Scene will connect - starting initialization")
        
        guard let windowScene = (scene as? UIWindowScene) else {
            logger.error("❌ Failed to cast scene to UIWindowScene")
            return
        }
        logger.info("✅ WindowScene created successfully")
        
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = AppColors.background
        logger.info("✅ Window initialized with AppColors.background")
        
        guard let window = window else {
            logger.error("❌ Window is nil after initialization")
            return
        }
        logger.info("✅ Window reference confirmed")
        
        logger.info("📦 Creating AppCoordinator with DependencyContainer")
        appCoordinator = AppCoordinator(window: window, container: container)
        
        guard let coordinator = appCoordinator else {
            logger.error("❌ AppCoordinator initialization failed")
            return
        }
        logger.info("✅ AppCoordinator created successfully")
        
        logger.info("▶️ Starting AppCoordinator")
        coordinator.start()
        logger.info("✅ AppCoordinator started - scene setup complete")
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        logger.info("📱 Scene did become active")
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        logger.info("📱 Scene will resign active")
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        logger.info("📱 Scene did enter background")
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        logger.info("📱 Scene will enter foreground")
    }
}
